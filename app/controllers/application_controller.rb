class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate_admin_user!
  end

  def access_denied(exception)
    redirect_to new_admin_user_session_path
  end
end
