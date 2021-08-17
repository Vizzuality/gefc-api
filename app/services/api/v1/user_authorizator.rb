module API
  module V1
    class UserAuthorizator
      def initialize(request)
        @request = request
      end

      def valid?
        @request.headers['Authentication'].present?
      end

      def authorize!
        return authorized_user?
      rescue ::JWT::ExpiredSignature
        return "Auth token has expired"
      rescue ::JWT::DecodeError
        return "Auth token is invalid"
      end

      def authorized_user?
        token = @request.headers.fetch('Authentication', '').split(' ').last
        payload = JsonWebToken.decode(token)
        User.find(payload['sub']).admin?
      end
    end
  end
end
