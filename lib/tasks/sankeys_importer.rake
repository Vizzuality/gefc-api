namespace :sankeys do
  desc "Imports sankeys from json files in local file system."
  task import_json: :environment do
    SandkeysImporter.new.import_from_multiple_json(ENV['file_path'])
  end
  desc "Imports sankeys from json files in local file system."
  task import_json_async: :environment do
    ImportSankeysJob.perform_later(ENV['file_path'])
  end
end
