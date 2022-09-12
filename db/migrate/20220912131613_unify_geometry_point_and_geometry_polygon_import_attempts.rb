class UnifyGeometryPointAndGeometryPolygonImportAttempts < ActiveRecord::Migration[6.1]
  def change
    rename_table :geometry_points_import_attempts, :geometry_import_attempts
    drop_table :geometry_polygons_import_attempts
  end
end
