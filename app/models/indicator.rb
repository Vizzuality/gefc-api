class Indicator < ApplicationRecord
    belongs_to :subgroup
    has_many :records
    has_many :indicator_widgets
    has_many :widgets, through: :indicator_widgets
    belongs_to :widget
end
