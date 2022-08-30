class ChangeGeometryToGeometryInsteadOfGeography < ActiveRecord::Migration[6.1]
  def change
    change_table :geometry_polygons do |t|
      remove_column :geometry_polygons, :geometry
      add_column :geometry_polygons, :geometry, :geometry, limit: {srid: 0, type: "geometry"}
    end
  end
end
