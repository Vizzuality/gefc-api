class GroupsImportAttempt < ApplicationRecord
  after_create_commit :import_groups

  has_one_attached :original_file

  def import_groups
    file_path = ActiveStorage::Blob.service.path_for(original_file.key)
    GroupsImporter.new.import_from_csv(file_path)
  end
end
