class AddByDefaultToIndicatorWidgets < ActiveRecord::Migration[6.1]
  def up
    add_column :indicator_widgets, :by_default, :boolean, default: true, null: false
  end

  def down
    remove_column :indicator_widgets, :by_default
  end
end
