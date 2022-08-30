class RenameSandkey < ActiveRecord::Migration[6.1]
  def change
    rename_column :indicators, :sandkey, :sankey
  end
end
