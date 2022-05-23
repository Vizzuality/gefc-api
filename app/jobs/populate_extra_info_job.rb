class PopulateExtraInfoJob < ApplicationJob
  queue_as :default

  def perform()
    current_env = ENV["RAILS_ENV"] ||= ENV["RACK_ENV"] || "development"
    system "RAILS_ENV=#{current_env} bundle exec rails regions:populate_extra_info"      
    system "RAILS_ENV=#{current_env} bundle exec rails indicators:populate_extra_info"      
    system "RAILS_ENV=#{current_env} bundle exec rails indicators:populate_meta"      
    system "RAILS_ENV=#{current_env} bundle exec rails indicators:populate_sankey_meta"      
    system "RAILS_ENV=#{current_env} bundle exec rails records:populate_extra_info"      
  end
end
