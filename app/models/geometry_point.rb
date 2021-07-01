class GeometryPoint < ApplicationRecord
  belongs_to :region
  validates :geometry, presence: true
end
