namespace :geometries do
  namespace :points do
    desc "Imports point geometries from json in local file system."
    task import_geojson: :environment do
      GeometryPointsImporter.new.import_from_json(ENV['file_name'])
    end
  end

  namespace :polygons do
    desc "Imports polygon geometries from json in local file system."
    task import_geojson: :environment do
      GeometryPolygonsImporter.new.import_from_json(ENV['file_name'])
    end
  end
end