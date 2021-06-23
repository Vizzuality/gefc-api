class AddByDefaultUniqueIndexToSubgroups < ActiveRecord::Migration[6.1]
  def change
    add_index :subgroups, [:group_id, :by_default], unique: true, where: 'by_default'
  end
end
