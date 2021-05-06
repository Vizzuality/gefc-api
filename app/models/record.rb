class Record < ApplicationRecord
    belongs_to :indicator
    belongs_to :unit
    belongs_to :region
    has_many :record_widgets
    has_many :widgets, through: :record_widgets
end
