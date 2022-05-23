namespace :indicators do
  desc "populate_extra_info"
  task populate_extra_info: :environment do
    Indicator.all.each do |indicator|
      puts indicator.id
      # Can change for indicator.regions
      #
      indicator.region_ids = indicator.regions.pluck(:id)
      indicator.visualization_types = indicator.widgets_list
      indicator.default_visualization_name = indicator.default_visualization
      indicator.categories = indicator.category_1
      indicator.category_filters = indicator.get_category_filters
      indicator.start_date = indicator.get_start_date
      indicator.end_date = indicator.get_end_date
      indicator.serialized_scenarios = indicator.serialize_scenarios
      indicator.save!
    end
  end
  desc "populate_meta"
  task populate_meta: :environment do
    Indicator.all.each do |indicator|
      next if indicator.visualization_types.include?('sankey')
      
      indicator.meta = indicator.get_meta_object
      indicator.save!
    end
  end

  desc "populate meta for sankey"
  task populate_sankey_meta: :environment do
    Indicator.all.each do |indicator|
      if indicator.visualization_types.include?('sankey')
        meta_object = {}
        meta_object['default_visualization'] = 'sankey'
        years = []
        indicator.sandkey['data'].each { |data_item| years.push(data_item['year']) }
        years = years.uniq.sort
        
        regions = []
        indicator.regions.each do |current_region|
          region = {}
        region['id'] = current_region.id
        region['name_en'] = current_region.name_en
        region['name_cn'] = current_region.name_cn
        regions.push(region)
        end

        units = []
        indicator.units.each do |current_unit|
          unit = {}
          unit['id'] = current_unit.id
          unit['name_en'] = current_unit.name_en
          unit['name_cn'] = current_unit.name_cn
          units.push(unit)
        end

        meta_object['sankey'] = {
          'year'=> years,
          'regions'=> regions,
          'units'=> units,
          'scenarios'=> []
        }
        indicator.meta = meta_object
        indicator.save!
      end
    end
  end
end