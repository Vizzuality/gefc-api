class RemoveScenarioInfoFromRecord < ActiveRecord::Migration[6.1]
  def change
    remove_column :records, :scenario_info
  end
end
