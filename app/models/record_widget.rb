class RecordWidget < ApplicationRecord
  belongs_to :record
  belongs_to :widget

  after_create :update_visualization_types

  private
  def update_visualization_types
      self.record.visualization_types = self.record.widgets_list
      self.record.save!
  end
end
