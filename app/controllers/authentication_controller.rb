# class AuthenticationController < Devise::SessionsController
#   protect_from_forgery with: :exception, if: Proc.new { |c| c.request.format != 'application/json' }
# 	protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
#   skip_before_action :authenticate_user!, only: [:create]
    
#   respond_to :json
# end