class SankeyMeta
  def populate
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

    current_unit = API::V1::FindOrUpsertUnit.call({ name_en: "10000t" })

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

    current_unit = API::V1::FindOrUpsertUnit.call({ name_en: "10000tce" })

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
