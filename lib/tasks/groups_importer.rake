namespace :groups do
  desc "Imports groups records from csv in local file system."
  task import_csv: :environment do
    #GroupsImportJob.perform_now(ENV['file_name'])
    GroupsImportJob.perform_later(ENV['file_name'])
  end
end
