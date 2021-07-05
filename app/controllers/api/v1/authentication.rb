module API
	module V1
		module Authentication
			extend ActiveSupport::Concern

			included do
				helpers do
					def authenticate!
						user_authenticator = UserAuthenticator.new(request)
						return 'Auth token is invalid' unless user_authenticator.valid?
						user_authenticator.authenticate!
					end
					def api_authenticate!
						return true if request.headers['Api-Auth'].present? and request.headers['Api-Auth'] == ENV['API_CLIENT_KEY']
						false
					end
				end
			end
		end
	end
end