class IndicatorWidget < ApplicationRecord
  validates_uniqueness_of :by_default, scope: :indicator_id, if: :by_default?
  validates_uniqueness_of :widget_id, scope: :indicator_id

  belongs_to :indicator
  belongs_to :widget

  after_create :update_visualization_types

  scope :by_default, -> { where(by_default: true) }

  private
  def update_visualization_types
      self.indicator.visualization_types = self.indicator.widgets_list
      self.indicator.default_visualization_name = self.widget.name if self.by_default?
      self.indicator.save!
  end
end
