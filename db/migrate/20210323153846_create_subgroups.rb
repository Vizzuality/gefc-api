class CreateSubgroups < ActiveRecord::Migration[6.1]
  def change
    create_table :subgroups, id: :uuid do |t|
      t.uuid :group_id
      t.string :name

      t.timestamps
    end

    add_index :subgroups, :group_id
  end
end
