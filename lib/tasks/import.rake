namespace :import do
  desc "Imports data from files in local file system."
  task all: :environment do
    DataImporter.new.import(ENV["folder_name"])
  end
end
