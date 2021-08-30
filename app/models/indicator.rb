class IndicatorRegionException < StandardError; end

class Indicator < ApplicationRecord
    include Slugable

    validates_uniqueness_of :by_default, scope: :subgroup_id, if: :by_default?
    validates_uniqueness_of :name_en
    validates_presence_of :name_en

    belongs_to :subgroup
    has_many :records
    has_many :indicator_widgets
    has_many :widgets, through: :indicator_widgets
    has_one :default_indicator_widget, -> { by_default }, class_name: 'IndicatorWidget'
    has_one :default_widget, through: :default_indicator_widget, source: :widget

    delegate :group, to: :subgroup, allow_nil: true

    scope :by_default, -> { where(by_default: true) }

    translates :name, :description

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
    def category_filters
        category_filters = {}
        category_1.each do |category_1|
            category_filters[category_1] = records.
                where(Record.current_locale_column(:category_1) => category_1).
                pluck(Record.current_locale_column(:category_2)).
                uniq
        end
        category_filters
    end

    def start_date
        records.where("year > ?", 1900).order(year: :asc).pluck(:year).first
    end

    def end_date
        records.where("year > ?", 1900).order(year: :desc).pluck(:year).first
    end


    # Looks like Widgetable class is needed around...
    # 
    def widgets_list
        widgets.pluck(:name)
    end

    def self.find_by_id_or_slug!(slug_or_id, filters, includes)
        rel = Indicator.where('id::TEXT = :id OR slug = :id', id: slug_or_id)
        rel = rel.includes(*includes) if includes.any?
        rel = rel.where(filters) if filters.any?
        rel.first!
    end

    # Returns Regions for all indicator's records.
    # Raises exception if there are no Regions.
    #
    def regions
      regions = Region.where(id: records.select(:region_id))
      raise IndicatorRegionException.new("an error has ocurred:there are no regions for the indicator with id:#{id}") unless regions.any?
      regions
    end

    # Returns an Array of unique Scenarios names for all indicator's records.
    # Raises exception if there are no Regions.
    #
    def scenarios
        Scenario.where(id: records.select(:scenario_id).distinct).pluck(Scenario.current_locale_column(:name))
    end 
end
