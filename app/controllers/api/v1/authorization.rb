module API
  module V1
    module Authorization
      extend ActiveSupport::Concern

      included do
        helpers do
          def authorize!
            UserAuthorizator.new(request).authorize!
          end
        end
      end
    end
  end
end
