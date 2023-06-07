class IndicatorExtraInfo
  def populate
    Parallel.map(Indicator.all) do |indicator|
      puts indicator.id
      puts indicator.name_en
      indicator.region_ids = Region.where(id: indicator.records.select(:region_id)).pluck(:id)
      indicator.visualization_types = indicator.widgets_list
      indicator.default_visualization_name = indicator.default_visualization
      indicator.categories = indicator.category_1
      indicator.category_filters = indicator.get_category_filters
      indicator.start_date = indicator.get_start_date
      indicator.end_date = indicator.get_end_date
      indicator.scenarios = indicator.get_scenarios
      indicator.meta = indicator.get_meta_object unless indicator.visualization_types.include?("sankey")
      indicator.save!
    end
  end
end
