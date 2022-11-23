class AddDataImportAttempt < ActiveRecord::Migration[6.1]
  def change
    create_table :data_import_attempts, id: :uuid do |t|
      t.timestamps
      t.integer :status, default: 0
      t.string :message
      t.string :file_path
    end

  end
end
