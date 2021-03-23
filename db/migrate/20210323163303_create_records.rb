class CreateRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :records, id: :uuid do |t|
      t.uuid :indicator_id
      t.float :value
      t.integer :year
      t.string :category_1
      t.string :category_2
      t.string :category_3
      t.string :category_4

      t.timestamps
    end

    add_index :records, :indicator_id
  end
end
