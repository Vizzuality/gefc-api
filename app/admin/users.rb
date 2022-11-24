ActiveAdmin.register User do
  controller do

    def update
      model = :user

      if params[model][:password].blank?
        %w(password password_confirmation).each { |p| params[model].delete(p) }
      end

      super
    end
  end

  permit_params :email, :password, :password_confirmation, :role, :title, :name, :organization

  show title: :name do
    attributes_table do
      row :name
      row :email
      row :organization
      row :title
      row :role
      row :created_at
    end
  end

  index do
    selectable_column
    column "Email address" do |user|
      link_to user.email, admin_user_path(user)
    end
    column :name
    column :organization
    column :title
    column :role
    column :created_at
    actions
  end

  filter :name
  filter :email
  filter :organization
  filter :title
  filter :role

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :organization
      f.input :title
      f.input :role, as: :select, collection: User.roles.keys
      f.input :password
    end
    f.actions
  end
end
