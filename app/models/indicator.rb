class Indicator < ApplicationRecord
    before_validation :set_by_default, if: :by_default?
    validates_uniqueness_of :by_default, scope: :subgroup_id, if: :by_default?
    
    belongs_to :subgroup
    has_many :records
    has_many :indicator_widgets
    has_many :widgets, through: :indicator_widgets
    has_one :indicator_widget, -> { by_default }, class_name: 'IndicatorWidget'
    has_one :widget, through: :indicator_widget

    scope :by_default, -> { where(by_default: true) }

    translates :name, :description

    # TODO move it into an Indicator creator to avoid realying in callbacks
    #
    def set_by_default
        current_default = subgroup.indicator
        if current_default.present?
            current_default.by_default = false
            current_default.save!
        end
    end

    def default_visualization
        widget&.name
    end
    def category_1
        records.pluck(Record.current_locale_column(:category_1)).uniq
    end

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
end
