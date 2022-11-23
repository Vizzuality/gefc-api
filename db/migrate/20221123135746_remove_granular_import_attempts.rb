class RemoveGranularImportAttempts < ActiveRecord::Migration[6.1]
  def change
    drop_table :geometry_import_attempts
    drop_table :groups_import_attempts
    drop_table :widgets_import_attempts
  end
end
