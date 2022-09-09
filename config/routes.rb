Rails.application.routes.draw do
  get "/performance_tests", to: "performance_tests#index"

  devise_for :users, {class_name: "User"}.merge(ActiveAdmin::Devise.config)
  ActiveAdmin.routes(self)

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/, defaults: {locale: "en"} do
    mount API::Base, at: "/"
  end
  mount GrapeSwaggerRails::Engine, at: "/swagger"
end
