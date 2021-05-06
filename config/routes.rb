Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  mount API::Base, at: "/"
  mount GrapeSwaggerRails::Engine, at: "/swagger"
end
