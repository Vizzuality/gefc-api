namespace :groups do
  desc "Imports groups records from csv in local file system."
  task import_csv: :environment do
    GroupsImporter.new.import_from_csv(ENV['file_name'])
  end
end
