namespace :widgets do
  desc "Imports widgets from json in local file system."
  task import_json: :environment do
    WidgetsImporter.new.import_from_json(ENV['file_name'])
  end
end
