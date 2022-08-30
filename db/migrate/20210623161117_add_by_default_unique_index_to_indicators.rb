class AddByDefaultUniqueIndexToIndicators < ActiveRecord::Migration[6.1]
  def change
    add_index :indicators, [:subgroup_id, :by_default], unique: true, where: "by_default"
  end
end
