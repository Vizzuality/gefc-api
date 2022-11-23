ActiveAdmin.register DataImportAttempt do
  permit_params :file_path, :original_file
  config.sort_order = 'created_at_desc'

  controller do
    actions :all, :except => [:edit]
  end

  filter :status, as: :select

  index do
    selectable_column
    column "Created At" do |import|
      link_to import.created_at, admin_data_import_attempt_path(import)
    end
    tag_column :status
    actions
  end

  form do |f|
    panel 'Instructions' do
      render 'folder_structure.html.erb', { data_import_attempt: data_import_attempt }
    end

    f.semantic_errors # shows errors on :base
    f.inputs do
      f.input :original_file, as: :file
    end
    f.actions # adds the 'Submit' and 'Cancel' buttons
  end
end
