namespace :sankeys do
  desc "Imports sankeys from json in local file system."
  task import_json: :environment do
    SandkeysImporter.new.import_from_json(ENV['file_name'])
  end
  desc "Imports sankeys from json in local file system."
  task import_json_async: :environment do
    ImportSankeysJob.perform_later(ENV['file_name'])
  end
end
