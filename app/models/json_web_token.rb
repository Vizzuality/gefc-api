class JsonWebToken
  def self.encode(payload)
    expiration = 2.weeks.from_now.to_i
    JWT.encode payload.merge(exp: expiration), ENV['DEVISE_SECRET_KEY']
    #TO DO use secret
    # JWT.encode payload.merge(exp: expiration), Rails.application.credentials.fetch(:secret_key_base)
  end
  
  def self.decode(token)
    JWT.decode(token, ENV['DEVISE_SECRET_KEY']).first
    #TO DO use secret
    #JWT.decode(token, Rails.application.credentials.fetch(:secret_key_base)).first
  end
end
