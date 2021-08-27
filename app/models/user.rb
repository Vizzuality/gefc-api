class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  enum role: { guest: 0, admin:1 }
  
  # Returns a JWT with the id, role and expiration set to false.
  def jwt_token
    JsonWebToken.encode({sub: id, role: role}, false)
  end

  # Returns a JWT with the id, email and expiration date.
  def recover_password_token
    JsonWebToken.encode({sub: id, email: email}, true)
  end
end
