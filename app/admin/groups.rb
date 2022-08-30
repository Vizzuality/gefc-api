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
    permitted = [:name, :published, :description, :header_image]
    permitted
  end

  index do
    selectable_column
    id_column
    column :name
    column :published
    column :description
    column 'Header Image' do |group|
      group.header_image.filename
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :published
      f.input :description
      f.input :header_image, as: :file, input_html: { multiple: false }
      if f.object.header_image.attached?
        span do
          image_tag(f.object.header_image)
        end
      end
    end
    f.actions
  end

end
