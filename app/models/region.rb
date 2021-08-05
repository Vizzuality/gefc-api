class GeometryException < StandardError; end

class Region < ApplicationRecord
  has_many :records
  has_one :geometry_point
  has_one :geometry_polygon

  translates :name

  enum region_type: [:other, :global, :continent, :country, :province, :coal_power_plant]
  
  # Returns Geometry.
  # Raises exception if there is no geometry.
  #
  def geometry
    if coal_power_plant?
      raise GeometryException.new("an error has ocurred:there is no geometry for region with id:#{id}") if geometry_point.nil?
      geometry_point
    else
      raise GeometryException.new("an error has ocurred:there is no geometry for region with id:#{id}") if geometry_polygon.nil?
      geometry_polygon
    end
  end

  # Returns Geometry encoded.
  # Raises exception if there is no geometry.
  #
  def geometry_encoded
    begin
      RGeo::GeoJSON.encode(geometry.geometry)
    rescue GeometryException => e
      return nil
    end
  end
end
