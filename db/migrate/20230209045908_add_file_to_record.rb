class AddFileToRecord < ActiveRecord::Migration[6.1]
  def change
    add_column :records, :file, :string, :null => true
  end
end
