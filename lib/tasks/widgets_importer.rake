namespace :widgets do
  desc "Imports widgets from json in local file system."
  task import_json_file: :environment do
    WidgetsImporter.new.import_from_file(ENV["file_name"])
  end
  task import_json_folder: :environment do
    WidgetsImporter.new.import_from_folder(ENV["folder_name"])
  end
end
