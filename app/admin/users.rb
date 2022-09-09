ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :role

  show :title => :name do
    attributes_table do
      row :title
      row :name
      row :email
      row :organization
      row :created_at
      row :role
    end
  end

  index do
    selectable_column
    id_column
    column :title
    column :name
    column :email
    column :organization
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :role
    actions
  end

  filter :title
  filter :name
  filter :email
  filter :organization
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at
  filter :role

  form do |f|
    f.inputs do
      f.input :title
      f.input :name
      f.input :email
      f.input :organization
      f.input :password
      f.select :role, User.roles.keys, {}
    end
    f.actions
  end
end
