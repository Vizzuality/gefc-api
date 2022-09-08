class AddUnitNameRequired < ActiveRecord::Migration[6.1]
  def change
    change_column :units, :name_en, :string, null: false
  end
end
