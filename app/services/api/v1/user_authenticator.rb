module API
  module V1
    class UserAuthenticator
      def initialize(request)
        @request = request
      end

      def valid?
        @request.headers["Authentication"].present?
      end

      def authenticate!
        return false unless valid?
        current_user.present?
      rescue ::JWT::ExpiredSignature
        "Auth token has expired"
      rescue ::JWT::DecodeError
        "Auth token is invalid"
      end

      def current_user
        token = @request.headers.fetch("Authentication", "").split(" ").last
        payload = JsonWebToken.decode(token)
        User.find(payload["sub"])
      end
    end
  end
end
