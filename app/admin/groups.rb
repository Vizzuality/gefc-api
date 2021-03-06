ActiveAdmin.register Group do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :published, :description
  #
  # or
  #
  permit_params do
    permitted = [:name, :published, :description]
    permitted
  end

  index do
    selectable_column
    id_column
    column :name
    column :published
    column :description
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :published
      f.input :description
    end
    f.actions
  end
  
end
