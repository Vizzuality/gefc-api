class AddNotNullSlugs < ActiveRecord::Migration[6.1]
  def change
    change_column :groups, :slug, :string, null: false
    change_column :subgroups, :slug, :string, null: false
    change_column :indicators, :slug, :string, null: false
  end
end
