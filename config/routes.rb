Rails.application.routes.draw do
  mount API::Base, at: "/"
  mount GrapeSwaggerRails::Engine, at: "/swagger"
end
