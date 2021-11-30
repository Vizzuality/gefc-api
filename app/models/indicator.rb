class IndicatorRegionException < StandardError; end

class Indicator < ApplicationRecord
    include Slugable
    serialize :region_ids, Array
    serialize :visualization_types, Array
    serialize :categories, Array
    serialize :scenarios, Array
    serialize :category_filters, Hash
    serialize :meta, Hash
    serialize :sandkey, Hash

    validates_uniqueness_of :by_default, scope: :subgroup_id, if: :by_default?
    validates_uniqueness_of :name_en, scope: :subgroup_id
    validates_presence_of :name_en

    belongs_to :subgroup
    has_many :records
    has_many :indicator_widgets
    has_many :widgets, through: :indicator_widgets
    has_one :default_indicator_widget, -> { by_default }, class_name: 'IndicatorWidget'
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
            category_filters[category_1] = records.
                where(Record.current_locale_column(:category_1) => category_1).
                pluck(Record.current_locale_column(:category_2)).
                uniq
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
      regions = self.cached_regions
      raise IndicatorRegionException.new("an error has ocurred:there are no regions for the indicator with id:#{id}") unless regions.any?
      regions
    end

    def cached_regions
        cached_regions = Rails.cache.read("#{self.id}_cached_regions")
        unless cached_regions.present?
            cached_regions = Region.where(id: self.records.select(:region_id))
            Rails.cache.write("#{self.id}_cached_regions", cached_regions, expires_in: 1.day) if cached_regions.present?
        end

        return cached_regions
    end

    # Returns an Array of unique Scenarios names for all indicator's records.
    # Raises exception if there are no Regions.
    #
    def get_scenarios
        scenarios_array = []
        Scenario.where(id: records.select(:scenario_id).distinct).pluck(:id, Scenario.current_locale_column(:name)).each do |scenario|
            scenario_hash = {
                "id" => scenario[0],
                'name' => scenario[1]
            }
            scenarios_array.push(scenario_hash)
        end
        scenarios_array
    end

    def get_meta_object
        meta_object = {}
        visualization_types.each do |visualization_type|
            meta_object[visualization_type]= {}
            widget = Widget.where(name:visualization_type).first
            records = widget.records.where(indicator_id:self.id)
            years = records.pluck(:year).uniq
            meta_object[visualization_type]['year'] = years
            regions = []
            regions_ids_by_visualization = records.pluck(:region_id).uniq
            regions_ids_by_visualization.each do |region_id|
                region = {}
                region['id'] = region_id
                region['name'] = Region.find(region_id).name
                regions.push(region)
            end
            meta_object[visualization_type]['regions'] = regions
            units = []
            units_ids_by_visualization = records.pluck(:unit_id).uniq
            units_ids_by_visualization.each do |unit_id|
                unit = {}
                unit['id'] = unit_id
                unit['name'] = 
                if unit_id.nil?
                    unit_id
                else
                    Unit.find(unit_id).name
                end
                units.push(unit)
            end
            meta_object[visualization_type]['units'] = units
            scenarios = []
            records.where.not(scenario:nil).each do |record|
                scenarios.push(record.scenario_info["name"])
            end
            meta_object[visualization_type]['scenarios'] = scenarios
        end
        
        meta_object
    end
end
