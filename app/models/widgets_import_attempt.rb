class WidgetsImportAttempt < ApplicationRecord
  after_create_commit :import
  
  has_one_attached :original_file

  def import
    file_path = ActiveStorage::Blob.service.path_for(original_file.key)
    WidgetsImporter.new.import_from_json(file_path)
  end
end
