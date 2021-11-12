class AddUnitInfoToRecords < ActiveRecord::Migration[6.1]
  def change
    add_column :records, :unit_info, :text
  end
end
