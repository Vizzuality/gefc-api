class AddCategoriesAndCategoryFiltersToIndicators < ActiveRecord::Migration[6.1]
  def change
    add_column :indicators, :categories, :text
    add_column :indicators, :category_filters, :text
  end
end
