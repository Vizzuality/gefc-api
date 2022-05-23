class ImportGroupsFromMultipleFilesJob < ApplicationJob
  queue_as :default

  def perform(file_path)
    GroupsImporter.new.import_from_multiple_csv(file_path)    
  end

end
