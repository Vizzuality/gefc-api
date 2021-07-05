# class RegistrationsController < Devise::RegistrationsController
# 	protect_from_forgery with: :exception, if: Proc.new { |c| c.request.format != 'application/json' }
# 	protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
# 	# skip_before_action :authenticate_user!
# 	skip_before_action :verify_authenticity_token

# 	respond_to :json
# 	def create
# 		@user = User.new(sign_up_params)
# 		if @user.save
# 			render json: { user: @user, token: JsonWebToken.encode(sub: @user.id) }
# 		else
# 			render json: { errors: @user.errors }
# 		end
# 	end

# 	private
# 	def sign_up_params
# 		params.permit(:email, :password, :password_confirmation)
# 	end
# end