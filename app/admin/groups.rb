ActiveAdmin.register Group do
  permit_params do
    permitted = [:name, :description]
    permitted
  end

  index do
    selectable_column
    id_column
    column :name
    column :description
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
    end
    f.actions
  end
end
