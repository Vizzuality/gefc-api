module API
	module V1
		class Users < Grape::API
			include API::V1::Defaults
			include API::V1::Authentication

			resource :users do
				desc "Create a user and return email"
				params do
					requires :email, type: String, desc: "email of the user"
					requires :password, type: String, desc: "password"
					requires :password_confirmation, type: String, desc: "password confirmation"
				end
				post '/signup' do
					if api_authenticate! == true
						user = User.new(params)
						user.save!
						present user, with: API::V1::Entities::UserWithJWT
					else
						error!({ :error_code => 401, :error_message => authenticate! }, 401)
					end
				end

				desc "login a user and return email"
				params do
					optional :email, type: String, desc: "email of the user"
					optional :password, type: String, desc: "password"
				end
				post '/login' do
					if api_authenticate! == true
						user = User.find_by(email: params["email"].downcase)
						unless user&.valid_password?(params["password"])
							error!({:error_code => 401, :error_message => "Invalid email or password."}, 401)
						else
							present user, with: API::V1::Entities::UserWithJWT
						end
					else
						error!({ :error_code => 401, :error_message => authenticate! }, 401)
					end
				end
				
				desc "Returns the current user's information if the user is authenticated"
				get "/me" do
					if authenticate! == true
						user = user_authenticated
						present user, with: API::V1::Entities::UserInfo
					else
						error!({ :error_code => 401, :error_message => authenticate! }, 401)
					end
				end

				desc "Updates current user and Returns the current user's information if the user is authenticated"
				params do
					optional :email, type: String, desc: "email of the user"
					optional :password, type: String, desc: "password"
					optional :password_confirmation, type: String, desc: "password confirmation"
				end
				put "/me" do
					if authenticate! == true
						user = user_authenticated
						user.update(params)

						present user, with: API::V1::Entities::UserInfo
					else
						error!({ :error_code => 401, :error_message => authenticate! }, 401)
					end
				end
			end
		end
	end
end