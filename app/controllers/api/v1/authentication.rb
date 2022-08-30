module API
  module V1
    module Authentication
      extend ActiveSupport::Concern

      included do
        helpers do
          def authenticate!
            UserAuthenticator.new(request).authenticate!
          end

          def api_authenticate!
            api_authenticator = APIAuthenticator.new(request)
            return false unless api_authenticator.valid?
            api_authenticator.authenticate!
          end

          def user_authenticated
            user_authenticator = UserAuthenticator.new(request)
            user_authenticator.current_user
          end
        end
      end
    end
  end
end
