class AddStartDateAndEndDateToIndicators < ActiveRecord::Migration[6.1]
  def change
    add_column :indicators, :start_date, :int
    add_column :indicators, :end_date, :int
  end
end
