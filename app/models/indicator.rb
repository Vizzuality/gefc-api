class IndicatorRegionException < StandardError; end

class SankeyException < StandardError; end

class Indicator < ApplicationRecord
  include Slugable
  serialize :region_ids, Array
  serialize :visualization_types, Array
  serialize :categories, Array
  serialize :scenarios, Array
  serialize :category_filters, Hash

  validates_uniqueness_of :by_default, scope: :subgroup_id, if: :by_default?
  validates_uniqueness_of :name_en, scope: :subgroup_id
  validates_presence_of :name_en

  belongs_to :subgroup
  has_many :records
  has_many :indicator_widgets
  has_many :widgets, through: :indicator_widgets
  has_one :default_indicator_widget, -> { by_default }, class_name: "IndicatorWidget"
  has_one :default_widget, through: :default_indicator_widget, source: :widget

  delegate :group, to: :subgroup, allow_nil: true

  scope :by_default, -> { where(by_default: true) }

  translates :name, :description, :data_source

  def default_visualization
    default_widget&.name
  end

  # Returns an Array with records category_1.
  #
  def category_1
    records.pluck(Record.current_locale_column(:category_1)).uniq
  end

  # Returns an Array with records category_2 for each category_1.
  #
  def get_category_filters
    category_filters = {}
    category_1.each do |category_1|
      category_filters[category_1] = records
                                       .where(Record.current_locale_column(:category_1) => category_1)
                                       .pluck(Record.current_locale_column(:category_2))
                                       .uniq
    end
    category_filters
  end

  def get_start_date
    records.where("year > ?", 1900).order(year: :asc).pluck(:year).first
  end

  def get_end_date
    records.where("year > ?", 1900).order(year: :desc).pluck(:year).first
  end

  # Looks like Widgetable class is needed around...
  #
  def widgets_list
    widgets.pluck(:name)
  end

  def self.find_by_id_or_slug!(slug_or_id, filters, includes)
    API::V1::FetchIndicator.new.by_id_or_slug(slug_or_id, filters, includes)
  end

  # Returns Regions for all indicator's records.
  # Raises exception if there are no Regions.
  #
  def regions
    regions = cached_regions
    raise IndicatorRegionException.new("an error has occurred:there are no regions for the indicator with id:#{id}") unless regions.any?
    regions
  end

  def cached_regions
    cached_regions = Rails.cache.read("#{id}_cached_regions")
    unless cached_regions.present?
      cached_regions = Region.where(id: records.select(:region_id))
      Rails.cache.write("#{id}_cached_regions", cached_regions, expires_in: 1.day) if cached_regions.present?
    end

    cached_regions
  end

  # Returns an Array of unique Scenarios names for all indicator's records.
  # Raises exception if there are no Regions.
  #
  def get_scenarios
    scenarios_array = []
    Scenario.where(id: records.select(:scenario_id).distinct).pluck(:id, Scenario.current_locale_column(:name)).each do |scenario|
      scenario_hash = {
        "id" => scenario[0],
        "name" => scenario[1]
      }
      scenarios_array.push(scenario_hash)
    end
    scenarios_array
  end

  def get_meta_object
    meta_object = {}
    meta_object["default_visualization"] = if default_visualization_name.present?
      default_visualization_name
    else
      visualization_types.first
    end

    visualization_types.each do |visualization_type|
      meta_object[visualization_type] = {}
      widget = Widget.where(name: visualization_type).first
      records = widget.records.where(indicator_id: id)
      years = records.pluck(:year).uniq
      meta_object[visualization_type]["year"] = years.sort
      regions = []
      regions_ids_by_visualization = records.pluck(:region_id).uniq
      regions_ids_by_visualization.each do |region_id|
        region = {}
        region["id"] = region_id
        region["name_en"] = Region.find(region_id).name_en
        region["name_cn"] = Region.find(region_id).name_cn
        regions.push(region)
      end
      meta_object[visualization_type]["regions"] = regions

      units = []
      units_ids_by_visualization = records.pluck(:unit_id).uniq
      units_ids_by_visualization.each do |unit_id|
        next if unit_id.nil?
        unit = {}
        unit["id"] = unit_id
        unit["name_en"] = Unit.find(unit_id).name_en
        unit["name_cn"] = Unit.find(unit_id).name_cn
        units.push(unit)
      end
      meta_object[visualization_type]["units"] = units

      scenarios = []
      records.where.not(scenario_id: nil).each do |record|
        scenarios.push({ id: record.scenario.id, name: record.scenario.name })
      end
      meta_object[visualization_type]["scenarios"] = scenarios.uniq
    end

    meta_object
  end

  # TODO: Grappe is calling this method twice every time that is exposed
  def meta_by_locale(locale)
    meta_by_locale = meta
    meta_by_locale.keys.each do |key|
      next if key == "default_visualization"
      meta_by_locale[key]["regions"].each do |region|
        if (locale == "cn") && region["name_cn"].present?
          region["name"] = region["name_cn"]
        elsif region["name_en"].present?
          region["name"] = region["name_en"]
        end
        region.delete("name_en")
        region.delete("name_cn")
      end
      meta_by_locale[key]["units"].each do |unit|
        if (locale == "cn") && unit["name_cn"].present?
          unit["name"] = unit["name_cn"]
        elsif unit["name_en"].present?
          unit["name"] = unit["name_en"]
        end
        unit.delete("name_en")
        unit.delete("name_cn")
      end
    end
    meta_by_locale
  end

  def has_sankey?
    raise SankeyException.new("an error has occurred:there is no sankey for the indicator with id:#{id}") unless sankey.present?
    sankey.present?
  end

  # TODO: Grappe is calling this method twice every time that is exposed
  def sankey_by_locale(locale, year, unit, region)
    # sankey_filtered_data = sankey_filter(year, unit, region)

    sankey_filtered_data = if [year, unit, region].any?
      sankey_filter(year, unit, region)
    else
      sankey
    end

    sankey_filtered_data["data"].each do |data|
      if (locale == "cn") && data["region_cn"].present?
        data["region"] = data["region_cn"]
      elsif data["region_en"].present?
        data["region"] = data["region_en"]
      end
      data.delete("region_en")
      data.delete("region_cn")

      if (locale == "cn") && data["units_cn"].present?
        data["units"] = data["units_cn"]
      elsif data["units_en"].present?
        data["units"] = data["units_en"]
      end
      data.delete("units_en")
      data.delete("units_cn")

      data["links"].each do |link|
        if (locale == "cn") && link["class_cn"].present?
          link["class"] = link["class_cn"]
        elsif link["class_en"].present?
          link["class"] = link["class_en"]
        end
        link.delete("class_en")
        link.delete("class_cn")
      end

      data["nodes"].each do |node|
        if (locale == "cn") && node["name_cn"].present?
          node["name"] = node["name_cn"]
        elsif node["name_en"].present?
          node["name"] = node["name_en"]
        end
        node.delete("name_en")
        node.delete("name_cn")
      end
    end

    sankey_filtered_data
  end

  def sankey_filter(year, unit, region)
    filtered_sankey = {}
    filtered_sankey["data"] = []
    sankey_to_filter = sankey["data"]

    # if [year, unit, region].all? { |str| str.nil? }
    #   year = (sankey["data"].map { |data| data.with_indifferent_access["year"] }).max
    # end

    if year.present?
      sankey_to_filter.each do |data|
        if data.with_indifferent_access["year"] == year
          filtered_sankey["data"].push(data)
        end
      end
    end

    if unit.present?
      unless filtered_sankey["data"].empty?
        sankey_to_filter = filtered_sankey["data"]
        filtered_sankey["data"] = []
      end

      sankey_to_filter.each do |data|
        if (data.with_indifferent_access["units_en"] == unit) || (data.with_indifferent_access["units"] == unit)
          filtered_sankey["data"].push(data)
        end
      end
    end

    if region.present?
      unless filtered_sankey["data"].empty?
        sankey_to_filter = filtered_sankey["data"]
        filtered_sankey["data"] = []
      end

      sankey_to_filter.each do |data|
        if (data.with_indifferent_access["region_en"] == region) || (data.with_indifferent_access["region"] == region)
          filtered_sankey["data"].push(data)
        end
      end
    end

    filtered_sankey
  end
end
