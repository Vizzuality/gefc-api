namespace :geometries do
  namespace :points do
    desc "Imports point geometries from json files in local file system."
    task import_geojson: :environment do
      GeometryPointsImporter.new.import_from_multiple_json(ENV['file_path'])
    end
    desc "ASYNC. Imports point geometries from json in local file system."
    task import_geojson_async: :environment do
      ImportPointsJob.perform_later(ENV['file_path'])
    end
  end

  namespace :polygons do
    desc "Imports polygon geometries from json files in local file system."
    task import_geojson: :environment do
      GeometryPolygonsImporter.new.import_from_multiple_json(ENV['file_path'])
    end
    desc "ASYNC. Imports polygon geometries from json files in local file system."
    task import_geojson_async: :environment do
      ImportPolygonsJob.perform_later(ENV['file_path'])
    end
  end
end