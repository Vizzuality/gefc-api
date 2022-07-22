namespace :groups do
  desc "Imports groups records from csv files in local file system."
  task import_csv: :environment do
    GroupsImporter.new.import_from_multiple_csv(ENV['file_path'])
  end

  desc "ASYNC. Imports groups records from csv files in local file system."
  task import_csv_async: :environment do
    ImportGroupsFromMultipleFilesJob.perform_later(ENV['file_path'])
  end
end
