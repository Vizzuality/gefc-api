class AddMetaToIndicators < ActiveRecord::Migration[6.1]
  def change
    add_column :indicators, :meta, :json
  end
end
