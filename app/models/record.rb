class Record < ApplicationRecord
    serialize :visualization_types, Array
    serialize :scenario_info
    serialize :unit_info

    belongs_to :indicator
    belongs_to :unit
    belongs_to :region
    belongs_to :scenario, optional: true
    has_many :record_widgets
    has_many :widgets, through: :record_widgets

    translates :category_1, :category_2, :category_3

    before_save :set_scenario_info, :set_unit_info
    after_save :update_indicator_region_ids

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

    private

    def update_indicator_region_ids
        self.indicator.region_ids.push(region.id) unless self.indicator.region_ids.include?(region.id)
        self.indicator.save!
    end

    def set_scenario_info
        return if scenario.nil?
        self.scenario_info = {
            'name' => scenario.name
        }
    end

    def set_unit_info
        self.unit_info = {
            'id' => unit.id,
            'name' => unit.name
        }
    end
end
