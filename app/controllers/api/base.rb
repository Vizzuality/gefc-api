module API
  class Base < Grape::API
    before do
      I18n.locale = params[:locale] || I18n.default_locale
    end

    mount API::V1::Base
  end
end
