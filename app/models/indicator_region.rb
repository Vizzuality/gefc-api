class IndicatorRegion < ApplicationRecord
  validates_uniqueness_of :region_id, scope: :indicator_id

  belongs_to :indicator
  belongs_to :region

  after_create :update_region_ids

  private
  def update_region_ids
    # can you do the same in a single line?
    self.indicator.region_ids = self.indicator.regions.pluck(:id)
    self.indicator.save!
  end
end
