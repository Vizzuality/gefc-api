class Indicator < ApplicationRecord
    belongs_to :subgroup
    has_many :records

    has_many :indicator_widgets
    has_many :widgets, through: :indicator_widgets
    #default widget
    belongs_to :widget, optional: true
end
