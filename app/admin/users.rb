ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :role, :username

  index do
    selectable_column
    id_column
    column :email
    column :username
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :role
    actions
  end

  filter :email
  filter :username
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at
  filter :role

  form do |f|
    f.inputs do
      f.input :email
      f.input :username
      f.select :role, User.roles.keys, {}
    end
    f.actions
  end

end
