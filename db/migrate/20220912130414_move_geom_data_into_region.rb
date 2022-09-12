class MoveGeomDataIntoRegion < ActiveRecord::Migration[6.1]
  def change
    drop_table :geometry_polygons
    drop_table :geometry_points

    add_column :regions, :geometry, :geometry, limit: {srid: 0, type: "geometry"}
    add_column :regions, :tooltip_properties, :json
  end
end
