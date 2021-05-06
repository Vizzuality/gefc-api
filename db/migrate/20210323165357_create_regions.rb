class CreateRegions < ActiveRecord::Migration[6.1]
  def change
    create_table :regions, id: :uuid do |t|
      t.string :name
      t.integer :region_type

      t.timestamps
    end
  end
end
