namespace :api_jwt do
  desc "Imports widgets from json in local file system."
  task generate: :environment do
    puts API::V1::APIJwtGenerator.new.api_jwt
  end
end
