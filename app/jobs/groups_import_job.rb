class GroupsImportJob < ApplicationJob
  queue_as :default

  def perform(file_name)
    GroupsImporter.new.import_from_csv(file_name)
  end
end
