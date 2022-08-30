class AddUnitsToRecords < ActiveRecord::Migration[6.1]
  def change
    change_table :records do |t|
      t.uuid :unit_id
    end

    add_index :records, :unit_id
  end
end
