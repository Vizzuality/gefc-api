class AddDefaultVisualizationNameToIndicators < ActiveRecord::Migration[6.1]
  def change
    add_column :indicators, :default_visualization_name, :text
  end
end
