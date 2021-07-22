class CreateWidgetsImportAttempts < ActiveRecord::Migration[6.1]
  def change
    create_table :widgets_import_attempts, id: :uuid do |t|
      t.timestamps
      t.integer :total_rows_count
      t.integer :imported_records_count
      t.integer :jid
      t.integer :status
      t.string :file_path
    end
  end
end
