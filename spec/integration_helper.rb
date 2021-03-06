module IntegrationHelper
  def parsed_body
    JSON.parse(last_response.body)  
  end

  def login_and_get_jwt(user)
    header "Api-Auth", Rails.application.credentials.api_valid_jwt
    params = { 'email': user.email, "password": user.password }
    post "/api/v1/users/login", params, as: :json

    parsed_body["jwt_token"]
  end
end
