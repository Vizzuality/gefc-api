class IndicatorWidget < ApplicationRecord
  validates_uniqueness_of :by_default, scope: :indicator_id, if: :by_default?
  validates_uniqueness_of :widget_id, scope: :indicator_id

  belongs_to :indicator
  belongs_to :widget

  after_create :update_visualization_types

  scope :by_default, -> { where(by_default: true) }

  private

  def update_visualization_types
    indicator.visualization_types = indicator.widgets_list
    indicator.default_visualization_name = widget.name if by_default?
    indicator.save!
  end
end
