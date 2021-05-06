namespace :groups do
  desc "Imports groups records from csv in local file system."
  task import_csv: :environment do
    #EmissionsImporterJob.perform_later(ENV['csv_folder_path'] + ENV['file_name'])
    # development:
    # file_name: "emissions.csv"
    # csv_folder_path: "/storage/development/csv/"
    GroupsImporter.new.import_from_csv('/storage/development/csv/' + 'socioecon_short.csv')
  end
end
