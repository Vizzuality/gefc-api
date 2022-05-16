class CreateIndicatorScenarios < ActiveRecord::Migration[6.1]
  def change
    create_table :indicator_scenarios, id: :uuid do |t|
      t.uuid :indicator_id
      t.uuid :scenario_id

      t.timestamps
    end
  end
end
