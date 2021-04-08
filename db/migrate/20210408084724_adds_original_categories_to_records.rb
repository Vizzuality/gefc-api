class AddsOriginalCategoriesToRecords < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        add_column :records, :original_categories, :json
      end
      dir.down do
        remove_column :records, :original_categories
      end
    end
  end
end
