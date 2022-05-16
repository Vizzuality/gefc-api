class CreateIndicatorUnits < ActiveRecord::Migration[6.1]
  def change
    create_table :indicator_units, id: :uuid do |t|
      t.uuid :indicator_id
      t.uuid :unit_id

      t.timestamps
    end
  end
end
