require 'rails_helper'

RSpec.describe API::V1::Users do
  # Rack-Test helper methods like get, post, etc
  include Rack::Test::Methods
  
  describe 'POST user' do
    context 'When posting a user with invalid api token' do
      it 'returns 401' do
        header "Api-Auth", '12345'
        params = { 'email': "valid@example.com", "password": "password", 'password_confirmation':  "password" }
        post "/api/v1/users/signup", params, as: :json

        expect(last_response.status).to eq 401
      end
    end
    context 'When posting a user with valid params and valid Api-Auth' do
      it 'returns 200 and status ok' do
        header "Api-Auth", Rails.application.credentials.api_valid_jwt
        params = { 'email': "valid@example.com", "password": "password", 'password_confirmation':  "password" }
        post "/api/v1/users/signup", params, as: :json

        expect(last_response.status).to eq 201
      end
      it 'returns email and jwt_token with the user id' do
        header "Api-Auth", Rails.application.credentials.api_valid_jwt
        params = { 'email': "valid@example.com", "password": "password", 'password_confirmation':  "password" }
        post "/api/v1/users/signup", params, as: :json

        parsed_body = JSON.parse(last_response.body)
        new_user = User.find_by(email: params[:email])

        payload = JsonWebToken.decode(parsed_body["jwt_token"])
        payload_user_id = payload['sub']

        expect(parsed_body["email"]).to eq(params[:email])
        expect(payload_user_id).to eq(new_user.id)
      end
    end
  end

  describe 'POST users login' do
    let!(:user) { FactoryBot.create(:user, email: "valid@example.com", password: "password", password_confirmation: "password" ) }

    context 'When posting a users login with invalid api token' do
      it 'returns 401' do
        header "Api-Auth", '12345'
        params = { 'email': user.email, "password": "password" }
        post "/api/v1/users/login", params, as: :json

        expect(last_response.status).to eq 401
      end
    end

    context 'When login a user with valid params' do
      it 'returns 200 and status ok' do
        header "Api-Auth", Rails.application.credentials.api_valid_jwt
        params = { 'email': user.email, "password": "password" }
        post "/api/v1/users/login", params, as: :json

        expect(last_response.status).to eq 201
      end
      it 'returns email and jwt_token' do
        header "Api-Auth", Rails.application.credentials.api_valid_jwt
        params = { 'email': user.email, "password": "password" }
        post "/api/v1/users/login", params, as: :json

        parsed_body = JSON.parse(last_response.body)
        new_user = User.find_by(email: params[:email])
        payload = JsonWebToken.decode(parsed_body["jwt_token"])
        payload_user_id = payload['sub']

        expect(parsed_body["email"]).to eq(params[:email])
        expect(payload_user_id).to eq(new_user.id)
      end
    end
  end

  describe 'GET users info' do
    let!(:user) { FactoryBot.create(:user, email: "valid@example.com", password: "password", password_confirmation: "password" ) }
    
    context 'When logged in as a user with valid auth' do
      it 'returns 200 and status ok' do
        header "Authorization", login_and_get_jwt(user)
        get "/api/v1/users/me"

        expect(last_response.status).to eq 200
      end
      it 'returns the email of the logged in user' do
        header "Authorization", login_and_get_jwt(user)
        get "/api/v1/users/me"

        parsed_body = JSON.parse(last_response.body)

        expect(parsed_body["email"]).to eq(user.email)
      end
    end

    context 'When not logged in' do
      it 'returns 401 and status ok' do
        header "Authentication", ''
        get "/api/v1/users/me"

        expect(last_response.status).to eq 401
      end
    end
  end

  describe 'UPDATE users info' do
    let!(:user) { FactoryBot.create(:user, email: "valid@example.com", password: "password", password_confirmation: "password" ) }

    context 'When logged in as a user with valid auth' do
      it 'returns 201' do
        header "Authorization", login_and_get_jwt(user)
        params = { 'email': "new_email@example.com" }
        put "/api/v1/users/me", params, as: :json

        expect(last_response.status).to eq 200
      end
      it 'returns the updated user' do
        header "Authorization", login_and_get_jwt(user)
        params = { 'email': "new_email@example.com" }
        put "/api/v1/users/me", params, as: :json

        parsed_body = JSON.parse(last_response.body)

        expect(parsed_body["email"]).to eq("new_email@example.com")
      end
    end
  end
end
