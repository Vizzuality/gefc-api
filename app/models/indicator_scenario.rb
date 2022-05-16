class IndicatorScenario < ApplicationRecord
  validates_uniqueness_of :scenario_id, scope: :indicator_id

  belongs_to :indicator
  belongs_to :scenario

  after_create :update_serialized_scenarios

  private
  def update_serialized_scenarios
    # can you do the same in a single line?
    self.indicator.serialized_scenarios = indicator.serialize_scenarios
    self.indicator.save!
  end
end
