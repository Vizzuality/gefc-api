class RemoveUnitInfoFromRecord < ActiveRecord::Migration[6.1]
  def change
    remove_column :records, :unit_info
  end
end
