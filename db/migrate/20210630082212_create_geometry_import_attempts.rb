class CreateGeometryImportAttempts < ActiveRecord::Migration[6.1]
  def change
    create_table :geometry_points_import_attempts, id: :uuid do |t|
      t.timestamps
      t.integer :total_rows_count
      t.integer :imported_records_count
      t.integer :jid
      t.integer :status
      t.string :file_path
    end

    create_table :geometry_polygons_import_attempts, id: :uuid do |t|
      t.timestamps
      t.integer :total_rows_count
      t.integer :imported_records_count
      t.integer :jid
      t.integer :status
      t.string :file_path
    end
  end
end
