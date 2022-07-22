class ImportPointsJob < ApplicationJob
  queue_as :default

  def perform(file_path)
    GeometryPointsImporter.new.import_from_multiple_json(file_path)  
  end
end
