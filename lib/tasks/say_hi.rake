namespace :say do
  desc "Imports groups records from csv in local file system."
  task hi: :environment do
    HelloWorldJob.perform_later
  end
end
