class AddForeignKeys < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :indicator_widgets, :indicators
    add_foreign_key :indicator_widgets, :widgets
    add_foreign_key :subgroups, :groups
    add_foreign_key :records, :indicators
    add_foreign_key :records, :units
    add_foreign_key :records, :regions
    add_foreign_key :record_widgets, :widgets
    add_foreign_key :record_widgets, :records
  end
end
