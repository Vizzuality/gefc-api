class IndicatorWidget < ApplicationRecord
  before_validation :set_by_default, if: :by_default?
  validates_uniqueness_of :by_default, scope: :indicator_id, if: :by_default?
  validates_uniqueness_of :widget_id, scope: :indicator_id

  belongs_to :indicator
  belongs_to :widget

  scope :by_default, -> { where(by_default: true) }

  def set_by_default
    current_default = IndicatorWidget.by_default.where(indicator_id: indicator.id)&.first
    if current_default.present? and current_default != self
        current_default.by_default = false
        current_default.save!
    end
end
end
