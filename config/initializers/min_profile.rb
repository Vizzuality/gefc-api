if ENV["RAILS_ENV"] == "develop"
  Rack::MiniProfiler.config.authorization_mode = :allow_all
end
