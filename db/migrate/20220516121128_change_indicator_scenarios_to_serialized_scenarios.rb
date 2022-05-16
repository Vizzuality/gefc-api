class ChangeIndicatorScenariosToSerializedScenarios < ActiveRecord::Migration[6.1]
  def change
    rename_column :indicators, :scenarios, :serialized_scenarios
  end
end
