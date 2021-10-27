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
      cached_geometry_encoded = Rails.cache.read("#{self.id}_cached_geometry_encoded")
      unless cached_geometry_encoded.present?
          cached_geometry_encoded = RGeo::GeoJSON.encode(geometry.geometry)
          Rails.cache.write("#{self.id}_cached_geometry_encoded", cached_geometry_encoded, expires_in: 1.day) if cached_geometry_encoded.present?
      end

      return cached_geometry_encoded
      
    rescue GeometryException => e
      return nil
    end
  end
end
