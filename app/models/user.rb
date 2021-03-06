class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  enum role: { guest: 0, admin:1 }
  
  # Returns a JWT with the id.
  def jwt_token
    JsonWebToken.encode(sub: id, role: role)
  end
end
