class Record < ApplicationRecord
    serialize :visualization_types, Array
    serialize :scenario_info
    serialize :unit_info

    belongs_to :indicator
    belongs_to :unit, optional: true
    belongs_to :region
    belongs_to :scenario, optional: true
    has_many :record_widgets
    has_many :widgets, through: :record_widgets

    translates :category_1, :category_2, :category_3

    before_save :set_scenario_info, :set_unit_info
    #after_save :update_indicator_region_ids

    def widgets_list
        widgets.pluck(:name).uniq
    end

    private

    # def update_indicator_region_ids
    #     self.indicator.region_ids.push(region.id) unless self.indicator.region_ids.include?(region.id)
    #     self.indicator.save!
    # end

    def set_scenario_info
        return if scenario.nil?
        self.scenario_info = {
            'id' => scenario.id,
            'name' => scenario.name
        }
    end

    def set_unit_info
        self.unit_info = {
            'id' => unit&.id,
            'name' => unit&.name
        }
    end

    def set_visualization_types
        self.visualization_types = self.widgets_list
    end
end
