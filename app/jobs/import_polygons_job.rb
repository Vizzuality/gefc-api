class ImportPolygonsJob < ApplicationJob
  queue_as :default

  def perform(file_path)
    GeometryPolygonsImporter.new.import_from_multiple_json(file_path)  
  end
end
