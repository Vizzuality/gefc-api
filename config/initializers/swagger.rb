GrapeSwaggerRails.options.before_action do
  GrapeSwaggerRails.options.url = "#{Rails.configuration.relative_url_root}/swagger_doc"
  GrapeSwaggerRails.options.app_url = ENV["API_BASE_URL"] || ""
end
