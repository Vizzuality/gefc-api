module API
  module V1
    class APIJwtGenerator
      def initialize
      end

      def api_jwt
        JsonWebToken.encode({ sub: Rails.application.credentials.api_client_key }, false)
      end
    end
  end
end
