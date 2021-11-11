class AddGeometryEncodedToRegions < ActiveRecord::Migration[6.1]
  def change
    add_column :regions, :geometry_encoded, :json
  end
end
