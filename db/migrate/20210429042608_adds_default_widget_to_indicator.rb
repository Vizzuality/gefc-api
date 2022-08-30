class AddsDefaultWidgetToIndicator < ActiveRecord::Migration[6.1]
  def change
    change_table :indicators do |t|
      t.uuid :widget_id
    end

    add_index :indicators, :widget_id
  end
end
