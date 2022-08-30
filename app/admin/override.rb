ActiveAdmin::Devise::SessionsController.class_eval do
  def after_sign_out_path_for(resource_or_scope)
    '/'
  end

  def after_sign_in_path_for(resource_or_scope)
    prefix = Rails.configuration.action_controller[:relative_url_root] || ""
    prefix + '/admin'
  end
end
