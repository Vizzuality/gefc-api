module IntegrationHelper
  def parsed_body
    JSON.parse(last_response.body)  
  end

  def find_by_id(id)
    parsed_body.each do |element|
      return element if element["id"] == id
    end
    return false
  end

  def login_and_get_jwt(user)
    header "Api-Auth", Rails.application.credentials.api_valid_jwt
    params = { 'email': user.email, "password": user.password }
    post "/api/v1/users/login", params, as: :json

    parsed_body["jwt_token"]
  end

  def body_as_json
    json_str_to_hash(last_response.body)
  end
  
  def json_str_to_hash(str)
    JSON.parse(str).with_indifferent_access
  end
end
