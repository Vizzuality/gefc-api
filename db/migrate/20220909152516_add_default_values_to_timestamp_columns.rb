class AddDefaultValuesToTimestampColumns < ActiveRecord::Migration[6.1]
  def change
    change_column :records, :created_at, :datetime, default: Time.now
    change_column :records, :updated_at, :datetime, default: Time.now
    change_column :record_widgets, :created_at, :datetime, default: Time.now
    change_column :record_widgets, :updated_at, :datetime, default: Time.now
  end
end
