class RemoveSomeCategoriesFromRecords < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        remove_column :records, :category_3
        remove_column :records, :category_4
      end
      dir.down do
        add_column :records, :category_3, :string
        add_column :records, :category_4, :string
      end
    end
  end
end
