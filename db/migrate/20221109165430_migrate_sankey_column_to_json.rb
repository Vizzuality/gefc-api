class MigrateSankeyColumnToJson < ActiveRecord::Migration[6.1]
  def change
    remove_column :indicators, :sankey
    add_column :indicators, :sankey, :json
  end
end
