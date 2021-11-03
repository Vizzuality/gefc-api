class Record < ApplicationRecord
    belongs_to :indicator
    belongs_to :unit
    belongs_to :region
    belongs_to :scenario, optional: true
    has_many :record_widgets
    has_many :widgets, through: :record_widgets

    translates :category_1, :category_2, :category_3

    def widgets_list
        cached_widgets_list
    end

    def cached_widgets_list
        API::V1::FetchRecord.new.widgets_list(self)
    end

    def cached_scenario
        API::V1::FetchRecord.new.scenario(self)
    end

    def cached_region
        API::V1::FetchRecord.new.region(self)
    end

    def cached_unit
        API::V1::FetchRecord.new.unit(self)
    end
end
