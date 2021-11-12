namespace :indicators do
  desc "Populate indicator.region_ids"
  task populate_region_ids: :environment do
    Indicator.all.each do |indicator|
      indicator.region_ids = indicator.regions.pluck(:id)
      indicator.save!
    end
  end
  desc "update_visualization_types"
  task update_visualization_types: :environment do
    Indicator.all.each do |indicator|
      indicator.visualization_types = indicator.widgets_list
      indicator.default_visualization_name = indicator.default_visualization
      indicator.categories = indicator.category_1
      indicator.category_filters = indicator.get_category_filters
      indicator.start_date = indicator.get_start_date
      indicator.end_date = indicator.get_end_date
      indicator.scenarios = indicator.get_scenarios
      indicator.save!
    end
  end
end
