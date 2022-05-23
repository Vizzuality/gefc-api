class ImportWidgetsFromMultipleFilesJob < ApplicationJob
  queue_as :default

  def perform(file_path)
    WidgetsImporter.new.import_from_multiple_json(file_path)    
  end

end
