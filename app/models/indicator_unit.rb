class IndicatorUnit < ApplicationRecord
  validates_uniqueness_of :unit_id, scope: :indicator_id

  belongs_to :indicator
  belongs_to :unit
end
