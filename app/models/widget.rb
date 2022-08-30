class Widget < ApplicationRecord
  has_many :indicator_widgets
  has_many :indicators, through: :indicator_widgets

  has_many :record_widgets
  has_many :records, through: :record_widgets
end
