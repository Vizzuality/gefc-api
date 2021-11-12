class IndicatorRegionException < StandardError; end

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
    has_one :default_indicator_widget, -> { by_default }, class_name: 'IndicatorWidget'
    has_one :default_widget, through: :default_indicator_widget, source: :widget

    delegate :group, to: :subgroup, allow_nil: true

    scope :by_default, -> { where(by_default: true) }

    translates :name, :description, :data_source

    def default_visualization
        cached_default_visualization
    end

    def cached_default_visualization
        API::V1::FetchIndicator.new.default_visualization(self)
    end



    # Returns an Array with records category_1.
    #
    def category_1
        # cached_category_1
        records.pluck(Record.current_locale_column(:category_1)).uniq
    end

    def cached_category_1
        API::V1::FetchIndicator.new.category_1(self)
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
        cached_widgets_list
    end

    def cached_widgets_list
        API::V1::FetchIndicator.new.widgets_list(self)
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
        Scenario.where(id: records.select(:scenario_id).distinct).pluck(Scenario.current_locale_column(:name))
    end 
end
