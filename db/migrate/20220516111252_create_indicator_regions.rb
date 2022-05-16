class CreateIndicatorRegions < ActiveRecord::Migration[6.1]
  def change
    create_table :indicator_regions, id: :uuid do |t|
      t.uuid :indicator_id
      t.uuid :region_id

      t.timestamps
    end
  end
end
