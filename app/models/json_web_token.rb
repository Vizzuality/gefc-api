class JsonWebToken
  def self.encode(payload)
    expiration = 2.weeks.from_now.to_i
    JWT.encode payload.merge(exp: expiration), ENV['DEVISE_SECRET_KEY']
  end
  
  def self.decode(token)
    JWT.decode(token, ENV['DEVISE_SECRET_KEY'])&.first
  end
end
