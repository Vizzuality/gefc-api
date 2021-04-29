class Widget < ApplicationRecord
    has_many :indicator_widgets
    has_many :indicators, through: :indicator_widgets
end
