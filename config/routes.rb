Rails.application.routes.draw do
  devise_for :users
  mount API::Base, at: "/"
  mount GrapeSwaggerRails::Engine, at: "/swagger"
end
