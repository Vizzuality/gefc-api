class AddScenarioInfoToRecords < ActiveRecord::Migration[6.1]
  def change
    add_column :records, :scenario_info, :text, default: nil
  end
end
