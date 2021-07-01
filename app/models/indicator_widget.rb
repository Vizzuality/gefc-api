class IndicatorWidget < ApplicationRecord
  validates_uniqueness_of :by_default, scope: :indicator_id, if: :by_default?
  validates_uniqueness_of :widget_id, scope: :indicator_id

  belongs_to :indicator
  belongs_to :widget

  scope :by_default, -> { where(by_default: true) }
end
