class ImportWidgetsFromMultipleFilesJob < ApplicationJob
  queue_as :default

  def perform(file_path)
    #p "hello from ImportFromMultipleFilesJob #{Time.now().strftime('%F - %H:%M:%S.%L')}"
    WidgetsImporter.new.import_from_multiple_json(file_path)    
  end

end
