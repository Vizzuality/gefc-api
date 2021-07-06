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
						return false unless request.headers['Api-Auth'].present?

						token = request.headers['Api-Auth']
						segments_count = token.split('.').count
						return false unless segments_count >= 2

						payload = JsonWebToken.decode(token)
						return false unless (payload['sub'] .present?) and (payload['sub'] == ENV['API_CLIENT_KEY'])
						return true
					end

					def api_jwt
						JsonWebToken.encode(sub: ENV['API_CLIENT_KEY'])
					end
				end
			end
		end
	end
end