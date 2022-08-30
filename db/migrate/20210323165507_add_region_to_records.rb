class AddRegionToRecords < ActiveRecord::Migration[6.1]
  def change
    change_table :records do |t|
      t.uuid :region_id
    end

    add_index :records, :region_id
  end
end
