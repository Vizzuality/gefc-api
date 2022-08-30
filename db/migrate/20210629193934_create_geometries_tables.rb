class CreateGeometriesTables < ActiveRecord::Migration[6.1]
  def change
    create_table :geometry_points, id: :uuid do |t|
      t.references :region
      t.geometry :geometry, geographic: true, limit: {srid: 0, type: "geometry"}
      t.timestamps
    end

    create_table :geometry_polygons, id: :uuid do |t|
      t.references :region
      t.geometry :geometry, geographic: true, limit: {srid: 0, type: "geometry"}
      t.timestamps
    end
  end
end
