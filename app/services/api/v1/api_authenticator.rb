module API
  module V1
    class APIAuthenticator
      def initialize(request)
        @request = request
      end

      def valid?
        return false unless @request.headers["Api-Auth"].present?
        token = @request.headers["Api-Auth"]
        segments_count = token.split(".").count
        return false unless segments_count >= 2
        true
      end

      def authenticate!
        token = @request.headers["Api-Auth"]
        payload = JsonWebToken.decode(token)
        return false unless payload["sub"].present? && (payload["sub"] == Rails.application.credentials.api_client_key)
        true
      end
    end
  end
end
