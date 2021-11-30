class AddSandkeyToIndicators < ActiveRecord::Migration[6.1]
  def change
    add_column :indicators, :sandkey, :text
  end
end
