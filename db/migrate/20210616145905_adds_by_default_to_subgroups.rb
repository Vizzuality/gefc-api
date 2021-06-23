class AddsDefaultToSubgroups < ActiveRecord::Migration[6.1]
  def up
    add_column :subgroups, :by_default, :boolean, default: true, null: false
  end

  def down
    remove_column :subgroups, :by_default
  end
end
