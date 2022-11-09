namespace :indicators do
  desc "populate_extra_info"
  task populate_extra_info: :environment do
    Parallel.map(Indicator.all) do |indicator|
      puts indicator.id
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

  desc "populate meta for sankey"
  task populate_sankey_meta: :environment do
    meta_object = {}
    meta_object["default_visualization"] = "sankey"
    energy_flows = Indicator.find_by_id_or_slug!("energy-flows-energy-flows", {}, [])
    years = []

    unless energy_flows.sankey.nil? || energy_flows.sankey["data"].nil?
      energy_flows.sankey["data"].each { |data_item| years.push(data_item["year"]) }
      years = years.uniq.sort
    end

    china = Region.where(name_en: "China").first
    regions = []
    region = {}
    region["id"] = china.id
    region["name_en"] = china.name_en
    region["name_cn"] = china.name_cn
    regions.push(region)

    current_unit = API::V1::FindOrUpsertUnit.call({name_en: "10000t"})

    units = []
    unit = {}
    unit["id"] = current_unit.id
    unit["name_en"] = current_unit.name_en
    unit["name_cn"] = current_unit.name_cn
    units.push(unit)

    meta_object["sankey"] = {
      "year" => years,
      "regions" => regions,
      "units" => units,
      "scenarios" => []
    }
    energy_flows.meta = meta_object
    energy_flows.save!

    meta_object = {}
    meta_object["default_visualization"] = "sankey"
    emission_flows = Indicator.find_by_id_or_slug!("energy-flows-emission-flows", {}, [])
    years = []

    unless emission_flows.sankey.nil? || emission_flows.sankey["data"].nil?
      emission_flows.sankey["data"].each { |data_item| years.push(data_item["year"]) }
      years = years.uniq.sort
    end

    current_unit = API::V1::FindOrUpsertUnit.call({name_en: "10000tce"})

    units = []
    unit = {}
    unit["id"] = current_unit.id
    unit["name_en"] = current_unit.name_en
    unit["name_cn"] = current_unit.name_cn
    units.push(unit)

    meta_object["sankey"] = {
      "year" => years,
      "regions" => regions,
      "units" => units,
      "scenarios" => []
    }
    emission_flows.meta = meta_object
    emission_flows.save!
  end
end
