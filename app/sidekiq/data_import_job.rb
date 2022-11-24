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

    temp_folder_path = File.join(Dir.tmpdir, (0...8).map { rand(65..90).chr }.join)

    begin
      data_import_attempt.update!(status: :running)

      if data_import_attempt.original_file&.attachment
        if Rails.application.config.active_storage.service.eql? :amazon
          data_import_attempt.original_file.open do |file|
            handle_zip(file, temp_folder_path)
          end
        else
          handle_zip(ActiveStorage::Blob.service.path_for(data_import_attempt.original_file.key), temp_folder_path)
        end
      end

      data_import_attempt.done!
      FileUtils.rm_rf(temp_folder_path)
      puts "Cleaning up and saving status..."
      data_import_attempt.done!
      puts "Done!"
    rescue => error
      puts "Error importing data: #{error}"
      data_import_attempt.status = "error"
      data_import_attempt.message = "Error importing data: #{error}"
      data_import_attempt.save
      FileUtils.rm_rf(temp_folder_path) if File.directory?(temp_folder_path)
    end
  end

  private

  def handle_zip(zip_file_path, temp_folder_path)
    Zip::File.open(zip_file_path) do |zip_file|
      zip_file.each do |file|

        file_path = File.join(temp_folder_path, file.name)

        puts "Extracting #{file.name} to #{file_path}"

        FileUtils.mkdir_p(File.dirname(file_path))
        zip_file.extract(file, file_path) unless File.exist?(file_path)
      end

      DataImporter.new.import(temp_folder_path)
    end
  end
end
