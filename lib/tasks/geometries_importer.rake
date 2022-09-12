namespace :geometries do
  desc "Imports geometries from json files in local file system."
  task import_geojson: :environment do
    GeometryImporter.new.import_from_folder(ENV["folder_name"])
  end
end
