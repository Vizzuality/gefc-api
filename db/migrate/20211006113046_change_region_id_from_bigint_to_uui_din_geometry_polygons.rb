class ChangeRegionIdFromBigintToUuiDinGeometryPolygons < ActiveRecord::Migration[6.1]
  def change
    remove_column :geometry_polygons, :region_id
    add_column :geometry_polygons, :region_id, :uuid
  end
end
