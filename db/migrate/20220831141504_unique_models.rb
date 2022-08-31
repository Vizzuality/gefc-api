class UniqueModels < ActiveRecord::Migration[6.1]
  def change
    add_index :indicators, [:name_en, :name_cn, :subgroup_id], unique: true
    add_index :groups, [:name_en, :name_cn], unique: true
    add_index :regions, [:name_en, :name_cn, :region_type], unique: true
    add_index :subgroups, [:group_id, :name_en, :name_cn], unique: true
    add_index :units, [:name_en, :name_cn], unique: true
    add_index :widgets, :name, unique: true
  end
end
