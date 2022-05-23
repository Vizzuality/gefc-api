namespace :geometries do
  namespace :points do
    desc "Imports point geometries from json in local file system."
    task import_geojson: :environment do
      GeometryPointsImporter.new.import_from_json(ENV['file_name'])
    end
    desc "Async. Imports point geometries from json in local file system."
    task import_geojson_async: :environment do
      ImportPointsJob.perform_later(ENV['file_name'])
    end
  end

  namespace :polygons do
    desc "Imports polygon geometries from json in local file system."
    task import_geojson: :environment do
      GeometryPolygonsImporter.new.import_from_json(ENV['file_name'])
    end
    desc "Async. Imports polygon geometries from json files in local file system."
    task import_geojson_async: :environment do
      ImportPolygonsJob.perform_later(ENV['file_path'])
    end
  end
end