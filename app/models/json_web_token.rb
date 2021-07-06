class JsonWebToken
  def self.encode(payload)
    expiration = 2.weeks.from_now.to_i
    JWT.encode payload.merge(exp: expiration), Rails.application.credentials.devise_secret_key
  end
  
  def self.decode(token)
    JWT.decode(token, Rails.application.credentials.devise_secret_key)&.first
  end
end
