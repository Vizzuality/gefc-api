module API
  module V1
    class Users < Grape::API
      include API::V1::Defaults
      include API::V1::Authorization

      resource :users do
        desc "Create a user and return email"
        params do
          requires :email, type: String, desc: "email of the user"
          requires :password, type: String, desc: "password"
          optional :password_confirmation, type: String, desc: "password confirmation"
          optional :username, type: String, desc: "username of the user"
          optional :name, type: String, desc: "name of the user"
          optional :organization, type: String, desc: "organization of the user"
          optional :title, type: String, desc: "title of the user"
        end
        post "/signup" do
          user = User.new(params)
          user.save!
          present user, with: API::V1::Entities::UserWithJWT
        end

        desc "login a user and return email"
        params do
          optional :email, type: String, desc: "email of the user"
          optional :password, type: String, desc: "password"
        end
        post "/login" do
          user = User.find_by(email: params["email"].downcase)
          if user&.valid_password?(params["password"])
            present user, with: API::V1::Entities::UserWithJWT
          else
            error!({error_code: 401, error_message: "Invalid email or password."}, 401)
          end
        end

        desc "Returns the current user's information if the user is authenticated", {
          headers: {
            "Authentication" => {
              description: "JWT that Validates the user",
              required: true
            }
          }
        }
        get "/me" do
          if authenticate! != true
            error!({error_code: 401, error_message: authenticate!}, 401)
          end

          user = current_user
          present user, with: API::V1::Entities::UserInfo
        end

        desc "Updates current user and Returns the current user's information if the user is authenticated", {
          headers: {
            "Authentication" => {
              description: "JWT that Validates the user",
              required: true
            }
          }
        }
        params do
          optional :email, type: String, desc: "email of the user"
          optional :password, type: String, desc: "current password"
          optional :new_password, type: String, desc: "new password"
          optional :password_confirmation, type: String, desc: "password confirmation"
          optional :username, type: String, desc: "username of the user"
        end
        put "/me" do
          if authenticate! != true
            error!({error_code: 401, error_message: authenticate!}, 401)
          end

          user = current_user
          if params["new_password"].present?
            if params["password"].nil?
              error!({error_code: 406, error_message: "Invalid current password"}, 406)
            end
            if user&.valid_password?(params["password"])
              params["password"] = params["new_password"]
              params.delete("new_password")
            else
              error!({error_code: 406, error_message: "Invalid current password"}, 406)
            end
          end

          user.update!(params)

          present user, with: API::V1::Entities::UserInfo
        end

        desc "Deletes the current user", {
          headers: {
            "Authentication" => {
              description: "JWT that Validates the user",
              required: true
            }
          }
        }
        delete "/me" do
          if authenticate! == true
            user = current_user
            user.destroy!

            {status: "ok"}
          else
            error!({error_code: 401, error_message: authenticate!}, 401)
          end
        end

        desc "Sends and email with restore password link"
        params do
          requires :email, type: String, desc: "email of the user"
        end
        get "/recover-password-token" do
          user = User.find_by(email: params["email"].downcase)
          if user
            UserMailer.restore_password_email(user, user.recover_password_token).deliver_later

            {status: "ok"}
          else
            error!({error_code: 406, error_message: "Invalid email"}, 406)
          end
        end
      end
    end
  end
end
