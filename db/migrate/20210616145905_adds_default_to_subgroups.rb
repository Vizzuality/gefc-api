class AddsDefaultToSubgroups < ActiveRecord::Migration[6.1]
  def up
    add_column :subgroups, :default, :boolean, default: false, null: false
  end

  def down
    remove_column :subgroups, :default
  end
end
