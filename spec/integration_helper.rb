module IntegrationHelper
  def parsed_body
    
  end

  def login_and_get_jwt(user)
    header "Api-Auth", ENV['API_VALID_JWT']
    params = { 'email': user.email, "password": user.password }
    post "/api/v1/users/login", params, as: :json

    parsed_body = JSON.parse(last_response.body)
    parsed_body["jwt_token"]
  end
end
