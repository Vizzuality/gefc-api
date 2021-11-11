class AddRegionIdsToIndicator < ActiveRecord::Migration[6.1]
  def change
    add_column :indicators, :region_ids, :text
  end
end
