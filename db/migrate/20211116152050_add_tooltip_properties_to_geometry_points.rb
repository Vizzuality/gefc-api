class AddTooltipPropertiesToGeometryPoints < ActiveRecord::Migration[6.1]
  def change
    add_column :geometry_points, :tooltip_properties, :json
  end
end
