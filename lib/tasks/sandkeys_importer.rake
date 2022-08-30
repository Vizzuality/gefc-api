namespace :sankeys do
  desc "Imports sankeys from json in local file system."
  task import_json: :environment do
    SankeysImporter.new.import_from_json(ENV["file_name"])
  end
end
