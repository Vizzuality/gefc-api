module API
  module V1
    module Authorization
      extend ActiveSupport::Concern

      included do
        helpers do
          def authenticate!
            UserAuthenticator.new(request).authenticate!
          end

          def current_user
            UserAuthenticator.new(request).current_user
          end
        end
      end
    end
  end
end
