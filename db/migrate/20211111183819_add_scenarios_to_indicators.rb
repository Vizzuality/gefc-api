class AddScenariosToIndicators < ActiveRecord::Migration[6.1]
  def change
    add_column :indicators, :scenarios, :text
  end
end
