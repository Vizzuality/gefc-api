class GeometryException < StandardError; end

class Region < ApplicationRecord
  has_many :records
  has_one :geometry_point
  has_one :geometry_polygon

  translates :name

  enum region_type: [:other, :global, :continent, :country, :province, :coal_power_plant, :countries_and_regions, :city, :generating_units, :transmission_line, :coal_enterprise]
  
  # Returns Geometry.
  # Raises exception if there is no geometry.
  #
  def geometry
    if region_types_with_points.include?(region_type)
      raise GeometryException.new("an error has ocurred:there is no geometry for region with id:#{id}") if geometry_point.nil?
      geometry_point
    else
      raise GeometryException.new("an error has ocurred:there is no geometry for region with id:#{id}") if geometry_polygon.nil?
      geometry_polygon
    end
  end

  # TODO:
  # tooltip_properties is only for points anymore?
  #
  # Returns Geometry encoded.
  # Raises exception if there is no geometry.
  #
  def get_geometry_encoded
    begin
      encoded = RGeo::GeoJSON.encode(geometry.geometry)
      encoded["tooltip_properties"] = geometry.tooltip_properties if geometry.class == GeometryPoint
      encoded
    rescue GeometryException => e
      return nil
    end
  end

  def region_types_with_points
    GeometryPoint.all.pluck(:region_id).map{ |region_id| Region.find(region_id).region_type }.uniq
  end
end
