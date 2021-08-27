require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  it "is valid with valid attributes" do
    expect(user).to be_valid
  end

  it "is guest by default" do
    expect(user.role).to eq('guest')
  end

  describe :jwt_token do
    let(:payload) { JsonWebToken.decode(user.jwt_token) }
    
    it "has the user id in the payload" do

      expect(payload['sub']).to eq(user.id)
    end
    it "does not expire" do
      
      expect(payload['exp']).to eq(nil)
    end
  end

  describe :recover_password_token do
    let(:payload) { JsonWebToken.decode(user.recover_password_token) }

    it "has the user id in the payload" do
      
      expect(payload['sub']).to eq(user.id)
    end
    it "does expire in the future" do
      expiration_date = Time.at(payload['exp']).to_datetime

      expect(expiration_date > DateTime.now).to be_truthy
    end
  end
end
