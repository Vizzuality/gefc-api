class ChangeRegionIdFromBigintToUuiDinGeometryPoints < ActiveRecord::Migration[6.1]
  def change
    remove_column :geometry_points, :region_id
    add_column :geometry_points, :region_id, :uuid
  end
end
