class ChangeUnitsToNullableToRecords < ActiveRecord::Migration[6.1]
  def change
    change_column :records, :unit_id, :uuid, null: true
  end
end
