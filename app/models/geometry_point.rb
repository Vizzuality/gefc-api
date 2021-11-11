class GeometryPoint < ApplicationRecord
  belongs_to :region
  validates :geometry, presence: true

  after_save :set_geometry_encoded

  private

  def set_geometry_encoded
    self.region.geometry_encoded = self.region.get_geometry_encoded
    self.region.save!
  end
end
