class Region < ApplicationRecord
  has_many :records
  has_one :geometry_point
  has_one :geometry_polygon

  translates :name

  enum region_type: [:other, :global, :continent, :country, :province, :coal_power_plant]

  def geometry
    if coal_power_plant?
      geometry_point
    else
      geometry_polygon
    end
  end
end
