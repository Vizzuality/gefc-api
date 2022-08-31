namespace :groups do
  desc "Imports groups records from csv in local file system."
  task import_csv_file: :environment do
    GroupsImporter.new.import_from_file(ENV["file_name"])
  end
  task import_csv_folder: :environment do
    GroupsImporter.new.import_from_folder(ENV["folder_name"])
  end
end
