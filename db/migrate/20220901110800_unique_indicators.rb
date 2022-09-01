class UniqueIndicators < ActiveRecord::Migration[6.1]
  def change
    add_index :indicators, :slug, unique: true
    add_foreign_key :indicators, :subgroups
  end
end
