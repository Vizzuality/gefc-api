namespace :indicators do
  desc "populate_extra_info"
  task populate_extra_info: :environment do
    Indicator.all.each do |indicator|
      puts indicator.id
      indicator.region_ids = Region.where(id: indicator.records.select(:region_id)).pluck(:id)
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
  desc "populate_meta"
  task populate_meta: :environment do
    Indicator.all.each do |indicator|
      puts indicator.id
      indicator.meta = indicator.get_meta_object
      indicator.save!
    end
  end
end
