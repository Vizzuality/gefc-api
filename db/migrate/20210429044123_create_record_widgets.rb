class CreateRecordWidgets < ActiveRecord::Migration[6.1]
  def change
    create_table :record_widgets, id: :uuid do |t|
      t.uuid :record_id
      t.uuid :widget_id

      t.timestamps
    end
  end
end
