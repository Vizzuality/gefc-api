class AddDatasourceToIndicator < ActiveRecord::Migration[6.1]
  def change
    add_column :indicators, :data_source_en, :string
    add_column :indicators, :data_source_cn, :string
  end
end
