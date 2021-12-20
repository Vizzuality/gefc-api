require "grape-swagger"

module API
  module V1
    class APICacheBuster < Grape::Middleware::Base
      def after
        @app_response[1]["Cache-Control"] = "public"
        @app_response
      end
    end
  end
end
