class AddByDefaultToIndicators < ActiveRecord::Migration[6.1]
  def up
    add_column :indicators, :by_default, :boolean, default: true, null: false
  end

  def down
    remove_column :indicators, :by_default
  end
end
