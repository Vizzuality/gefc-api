require "grape-swagger"

module API
  module V1
    class APICacheBuster < Grape::Middleware::Base
      def after
        if @app_response.present? and (Rails.env == 'staging' or Rails.env == 'production')
          @app_response[1]["Cache-Control"] = "public"
          @app_response
        end
      end
    end
  end
end
