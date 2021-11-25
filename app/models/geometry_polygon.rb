class GeometryPolygon < ApplicationRecord
  belongs_to :region
  validates :geometry, presence: true

  after_save :set_geometry_encoded_for_the_region

  private

  def set_geometry_encoded_for_the_region
    self.region.geometry_encoded = self.region.get_geometry_encoded
    self.region.save!
  end
end
