class JsonWebToken

  def self.encode(payload, expire = true)
    if expire
      expiration = 2.weeks.from_now.to_i
      payload = payload.merge(exp: expiration)
    end

    JWT.encode payload, Rails.application.credentials.devise_secret_key
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.credentials.devise_secret_key)&.first
  end
end
