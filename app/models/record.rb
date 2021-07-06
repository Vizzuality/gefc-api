class Record < ApplicationRecord
    belongs_to :indicator
    belongs_to :unit
    belongs_to :region
    has_many :record_widgets
    has_many :widgets, through: :record_widgets

    translates :category_1, :category_2, :category_3

    def widgets_list
        widgets.pluck(:name).uniq
    end
end
