class GeometryPolygon < ApplicationRecord
  belongs_to :region
  validates :geometry, presence: true

  after_save :set_geometry_encoded_for_the_region

  private

  def set_geometry_encoded_for_the_region
    region.geometry_encoded = region.get_geometry_encoded
    region.save!
  end
end
