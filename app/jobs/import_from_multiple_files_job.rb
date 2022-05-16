class ImportFromMultipleFilesJob < ApplicationJob
  queue_as :default

  def perform(file_path)
    p "hello from ImportFromMultipleFilesJob #{Time.now().strftime('%F - %H:%M:%S.%L')}"
    GroupsImporter.new.import_from_multiple_csv(file_path)    
  end

end
