class ChangeGeometryPointsToGeometryInsteadOfGeography < ActiveRecord::Migration[6.1]
  def change
    change_table :geometry_points do |t|
      remove_column :geometry_points, :geometry
      add_column :geometry_points, :geometry, :geometry, limit: {srid: 0, type: "geometry"}
    end
  end
end
