Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/, defaults: {locale: 'en'} do
    mount API::Base, at: '/'
  end
  mount GrapeSwaggerRails::Engine, at: "/swagger"
end
