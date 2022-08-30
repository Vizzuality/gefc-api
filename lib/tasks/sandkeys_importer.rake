namespace :sandkeys do
  desc "Imports sandkeys from json in local file system."
  task import_json: :environment do
    SandkeysImporter.new.import_from_json(ENV["file_name"])
  end
end
