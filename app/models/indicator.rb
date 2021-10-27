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
        cached_default_visualization = Rails.cache.read("#{self.id}_cached_default_visualization")
        unless cached_default_visualization.present?
            cached_default_visualization = default_widget.name
            Rails.cache.write("#{self.id}_cached_default_visualization", cached_default_visualization, expires_in: 1.day) if cached_default_visualization.present?
        end

        return cached_default_visualization
    end



    # Returns an Array with records category_1.
    #
    def category_1
        cached_category_1
    end

    def cached_category_1
        cached_category_1 = Rails.cache.read("#{self.id}_cached_category_1")
        unless cached_category_1.present?
            cached_category_1 = records.pluck(Record.current_locale_column(:category_1)).uniq
            Rails.cache.write("#{self.id}_cached_category_1", cached_category_1, expires_in: 1.day) if cached_category_1.present?
        end

        return cached_category_1
    end

    # Returns an Array with records category_2 for each category_1.
    #
    def category_filters
        cached_category_filters
    end

    def cached_category_filters
        cached_category_filters = Rails.cache.read("#{self.id}_cached_category_filters")
        unless cached_category_filters.present?
            cached_category_filters = {}
            category_1.each do |category_1|
                cached_category_filters[category_1] = cached_records.
                    where(Record.current_locale_column(:category_1) => category_1).
                    pluck(Record.current_locale_column(:category_2)).
                    uniq
            end
            Rails.cache.write("#{self.id}_cached_category_filters", cached_category_filters, expires_in: 1.day) if cached_category_filters.present?
        end

        return cached_category_filters
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
        cached_start_date = Rails.cache.read("#{self.id}_cached_start_date")
        unless cached_start_date.present?
            cached_start_date = self.cached_records.where("year > ?", 1900).order(year: :asc).pluck(:year).first
            Rails.cache.write("#{self.id}_cached_start_date", cached_start_date, expires_in: 1.day) if cached_start_date.present?
        end

        return cached_start_date
    end

    def end_date
        cached_end_date
    end

    def cached_end_date
        cached_end_date = Rails.cache.read("#{self.id}_cached_end_date")
        unless cached_end_date.present?
            cached_end_date = self.cached_records.where("year > ?", 1900).order(year: :desc).pluck(:year).first
            Rails.cache.write("#{self.id}_cached_end_date", cached_end_date, expires_in: 1.day) if cached_end_date.present?
        end

        return cached_end_date
    end


    # Looks like Widgetable class is needed around...
    # 
    def widgets_list
        cached_widgets_list
    end

    def cached_widgets_list
        cached_widgets_list = Rails.cache.read("#{self.id}_cached_widgets_list")
        unless cached_widgets_list.present?
            cached_widgets_list = widgets
            Rails.cache.write("#{self.id}_cached_widgets_list", cached_widgets_list, expires_in: 1.day) if cached_widgets_list.present?
        end

        return cached_widgets_list
    end

    def self.find_by_id_or_slug!(slug_or_id, filters, includes)
      cached_indicator = Rails.cache.read("#{slug_or_id}_indicator")
        unless cached_indicator.present?
          rel = Indicator.where('id::TEXT = :id OR slug = :id', id: slug_or_id)
          rel = rel.includes(*includes) if includes.any?
          rel = rel.where(filters) if filters.any?
          cached_indicator = rel.first!
          Rails.cache.write("#{slug_or_id}_indicator", cached_indicator, expires_in: 1.day) if cached_indicator.present?
        end

        return cached_indicator
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
            cached_regions = Region.where(id: self.cached_records.select(:region_id))
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
      cached_scenarios = Rails.cache.read("#{self.id}_cached_scenarios")
      unless cached_scenarios.present?
        if self.cached_records.select(:scenario_id).distinct.any?
          cached_scenarios = Scenario.where(id: self.cached_records.select(:scenario_id).distinct).pluck(Scenario.current_locale_column(:name))
        else
          cached_scenarios = nil
        end
        Rails.cache.write("#{self.id}_cached_scenarios", cached_scenarios, expires_in: 1.day)
      end

      return cached_scenarios
    end
end
