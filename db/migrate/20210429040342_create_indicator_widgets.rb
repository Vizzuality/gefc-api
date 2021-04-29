class CreateIndicatorWidgets < ActiveRecord::Migration[6.1]
  def change
    create_table :indicator_widgets, id: :uuid do |t|
      t.uuid :indicator_id
      t.uuid :widget_id

      t.timestamps
    end
  end
end
