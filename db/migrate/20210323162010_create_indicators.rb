class CreateIndicators < ActiveRecord::Migration[6.1]
  def change
    create_table :indicators, id: :uuid do |t|
      t.uuid :subgroup_id
      t.string :name

      t.timestamps
    end

    add_index :indicators, :subgroup_id
  end
end
