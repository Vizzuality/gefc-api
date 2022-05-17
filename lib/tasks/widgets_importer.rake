namespace :widgets do
  desc "Imports widgets from json in local file system."
  task import_json: :environment do
    WidgetsImporter.new.import_from_json(ENV['file_name'])
  end
  desc "ASYNC. Imports widgets from json in local file system."
  task import_json_async: :environment do
    ImportWidgetsFromMultipleFilesJob.perform_later(ENV['file_path'])
  end
end
