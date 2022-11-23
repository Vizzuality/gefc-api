require "zip"
require "tmpdir"
require "rake"
GefcApi::Application.load_tasks

class DataImportJob
  include Sidekiq::Job

  sidekiq_options lock: :until_and_while_executing, on_conflict: {
    server: :raise
  }

  def perform(data_import_id)
    puts "Starting data import with id #{data_import_id}"
    data_import_attempt = DataImportAttempt.find(data_import_id)

    return if data_import_id.nil?

    temp = File.join(Dir.tmpdir, (0...8).map { rand(65..90).chr }.join)

    begin
      data_import_attempt.update!(status: :running)

      if data_import_attempt.original_file&.attachment
        file_path = if Rails.env.development? || Rails.env.test?
          ActiveStorage::Blob.service.path_for(data_import_attempt.original_file.key)
        else
          data_import_attempt.original_file&.service_url&.split("?")&.first
        end
      end

      Zip::File.open(file_path) do |zip_file|
        zip_file.each do |f|

          f_path = File.join(temp, f.name)

          puts "Extracting #{f.name} to #{f_path}"

          FileUtils.mkdir_p(File.dirname(f_path))
          zip_file.extract(f, f_path) unless File.exist?(f_path)
        end

        DataImporter.new.import(temp)
        data_import_attempt.done!
      end

      FileUtils.rm_rf(temp)
      puts "Cleaning up and saving status..."
      data_import_attempt.done!
      puts "Done!"
    rescue => error
      puts "Error importing data: #{error}"
      data_import_attempt.status = "error"
      data_import_attempt.message = "Error importing data: #{error}"
      data_import_attempt.save
      FileUtils.rm_rf(temp) if File.directory?(temp)
    end
  end
end
