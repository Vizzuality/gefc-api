class Record < ApplicationRecord
  serialize :visualization_types, Array

  belongs_to :indicator
  belongs_to :unit, optional: true
  belongs_to :region
  belongs_to :scenario, optional: true
  has_many :record_widgets
  has_many :widgets, through: :record_widgets

  translates :category_1, :category_2, :category_3

  def widgets_list
    widgets.pluck(:name).uniq
  end

  private

  def set_visualization_types
    self.visualization_types = widgets_list
  end
end
