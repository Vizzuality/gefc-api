class GeometryException < StandardError; end

class Region < ApplicationRecord
  has_many :records
  has_one :geometry_point
  has_one :geometry_polygon

  translates :name

  enum region_type: [:other, :global, :continent, :country, :province, :city, :coal_power_plant, :generating_units, :transmission_line, :coal_enterprise]

  # Returns Geometry.
  # Raises exception if there is no geometry.
  #
  def geometry
    if coal_power_plant?
      raise GeometryException.new("an error has occurred:there is no geometry for region with id:#{id}") if geometry_point.nil?
      geometry_point
    else
      raise GeometryException.new("an error has occurred:there is no geometry for region with id:#{id}") if geometry_polygon.nil?
      geometry_polygon
    end
  end

  # Returns Geometry encoded.
  # Raises exception if there is no geometry.
  #
  def get_geometry_encoded
    # Rails.logger.info("Fetching region geometry_encoded here!")
    Rails.cache.fetch([self, "geometry_encoded"]) do
      encoded = RGeo::GeoJSON.encode(geometry.geometry)
      encoded["tooltip_properties"] = geometry.tooltip_properties if geometry.instance_of?(GeometryPoint)
      encoded
    end
  rescue GeometryException
    nil
  end
end
