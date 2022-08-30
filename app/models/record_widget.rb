class RecordWidget < ApplicationRecord
  belongs_to :record
  belongs_to :widget

  after_create :update_visualization_types

  private

  def update_visualization_types
    record.visualization_types = record.widgets_list
    record.save!
  end
end
