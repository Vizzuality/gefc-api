class ActiveAdminAdapter < ActiveAdmin::AuthorizationAdapter
  def authorized?(action, subject = nil)
    unless user.nil?
      user.admin? == true
    end
  end
end
