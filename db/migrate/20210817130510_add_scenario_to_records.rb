class AddScenarioToRecords < ActiveRecord::Migration[6.1]
  def change
    change_table :records do |t|
      t.uuid :scenario_id, :null => true, :by_default => nil
    end

    add_index :records, :scenario_id
  end
end
