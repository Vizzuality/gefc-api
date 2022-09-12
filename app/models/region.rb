class GeometryException < StandardError; end

class Region < ApplicationRecord
  has_many :records
  translates :name

  before_save :set_geometry_encoded

  enum region_type: [:other, :global, :continent, :country, :province, :city, :coal_power_plant, :generating_unit, :transmission_line, :coal_enterprise]

  # Returns Geometry encoded.
  # Raises exception if there is no geometry.
  #
  def get_geometry_encoded
    # Rails.logger.info("Fetching region geometry_encoded here!")
    Rails.cache.fetch([self, "geometry_encoded"]) do
      encoded = RGeo::GeoJSON.encode(geometry)
      encoded["tooltip_properties"] = tooltip_properties unless tooltip_properties.nil?
      encoded
    end
  rescue GeometryException
    nil
  end

  def set_geometry_encoded
    self.geometry_encoded = get_geometry_encoded
  end
end
