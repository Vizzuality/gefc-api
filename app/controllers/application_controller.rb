class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate_admin_user!
    puts "auth admin user"
    return false if current_user.nil?
    return true if current_user.role == "admin"
    redirect_to "/"
  end

  def access_denied(exception)
    redirect_to new_user_session_path
  end
end
