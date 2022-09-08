module API
  module V1
    class UserAuthenticator
      def initialize(request)
        @request = request
      end

      def valid?
        return false unless @request.headers["Authentication"].present?
        current_user.present?
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

      def is_admin_user?
        token = @request.headers.fetch("Authentication", "").split(" ").last
        payload = JsonWebToken.decode(token)
        User.find(payload["sub"]).admin?
      end
    end
  end
end
