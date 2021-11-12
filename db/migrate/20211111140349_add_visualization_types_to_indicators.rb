class AddVisualizationTypesToIndicators < ActiveRecord::Migration[6.1]
  def change
    add_column :indicators, :visualization_types, :text
  end
end
