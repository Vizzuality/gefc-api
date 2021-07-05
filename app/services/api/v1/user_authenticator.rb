module API
  module V1
    class UserAuthenticator
      def initialize(request)
        @request = request
      end

      def valid?
        @request.headers['Authorization'].present?
      end

      def authenticate!
        return true if current_user
      rescue ::JWT::ExpiredSignature
        return "Auth token has expired"
      rescue ::JWT::DecodeError
        return "Auth token is invalid"
      end

      def current_user
        token = @request.headers.fetch('Authorization', '').split(' ').last
        payload = JsonWebToken.decode(token)
        User.find(payload['sub'])
      end
    end
  end
end
