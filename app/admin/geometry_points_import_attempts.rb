ActiveAdmin.register GeometryPointsImportAttempt do
  menu parent: 'Import', label: 'Points', priority: 3

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :file_path, :original_file

  index do
    selectable_column
    id_column
    column :created_at
    column :file_path
    actions
  end

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
      f.input :original_file, as: :file
    end
    f.actions # adds the 'Submit' and 'Cancel' buttons
  end
end
