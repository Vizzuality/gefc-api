class CreateGroupsImportAttempts < ActiveRecord::Migration[6.1]
  def change
    create_table :groups_import_attempts, id: :uuid do |t|
      t.string :file_path

      t.timestamps
    end
  end
end
