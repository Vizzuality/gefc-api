class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # Returns a JWT with the id.
  def jwt_token
    JsonWebToken.encode(sub: id)
  end
end
