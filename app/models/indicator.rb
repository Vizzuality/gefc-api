class IndicatorRegionException < StandardError; end

class Indicator < ApplicationRecord
    include Slugable

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
        cached_category_1
    end

    def cached_category_1
        API::V1::FetchIndicator.new.category_1(self)
    end

    # Returns an Array with records category_2 for each category_1.
    #
    def category_filters
        cached_category_filters
    end

    def cached_category_filters
        API::V1::FetchIndicator.new.category_1(self)
    end

    def cached_records
        cached_records = Rails.cache.read("#{self.id}_cached_records")
        unless cached_records.present?
            cached_records = records
            Rails.cache.write("#{self.id}_cached_records", cached_records, expires_in: 1.day) if cached_records.present?
        end

        return cached_records
    end

    def start_date
        cached_start_date
    end

    def cached_start_date
        API::V1::FetchIndicator.new.start_date(self)
    end

    def end_date
        cached_end_date
    end

    def cached_end_date
        API::V1::FetchIndicator.new.end_date(self)
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
    def scenarios
        cached_scenarios        
    end
    
    def cached_scenarios
        API::V1::FetchIndicator.new.scenarios(self)
    end

    def cached_group
        API::V1::FetchIndicator.new.group(self)
    end

    def cached_subgroup
        API::V1::FetchIndicator.new.subgroup(self)
    end
end
