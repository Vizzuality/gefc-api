require 'rails_helper'

RSpec.describe API::V1::Downloads do
  # Rack-Test helper methods like get, post, etc
  include Rack::Test::Methods

  describe 'GET downloads' do
    let!(:user) { FactoryBot.create(:user, email: "valid@example.com", password: "password", password_confirmation: "password" ) }
    
    context 'When logged in as a user with valid role' do
      it 'returns 200 and status ok' do
        header "Authentication", login_and_get_jwt(user)
        get "/api/v1/downloads"

        expect(last_response.status).to eq 200
      end 
    end

    context 'When not logged in' do
      it 'returns 401' do
        header "Authentication", ''
        get "/api/v1/downloads"

        expect(last_response.status).to eq 401
      end
    end
  end
end
