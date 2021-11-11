class AddVisualizationTypesToRecords < ActiveRecord::Migration[6.1]
  def change
    add_column :records, :visualization_types, :text
  end
end
