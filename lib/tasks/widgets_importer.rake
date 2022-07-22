namespace :widgets do
  desc "Imports widgets from json files in local file system."
  task import_json: :environment do
    WidgetsImporter.new.import_from_multiple_json(ENV['file_path'])
  end
  desc "ASYNC. Imports widgets from json files in local file system."
  task import_json_async: :environment do
    ImportWidgetsFromMultipleFilesJob.perform_later(ENV['file_path'])
  end
end
