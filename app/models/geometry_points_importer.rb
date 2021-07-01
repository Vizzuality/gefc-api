class GeometryPointsImporter
  # @param file_path [String] absolute or relative to root
  def import_from_json(file_path)
    file = File.read(file_path)
    data_hash = JSON.parse(file)['features']
    GeometryPoint.delete_all
    puts "we are going to import #{data_hash.count} geometries if everything works fine"
    puts "points count >> #{GeometryPoint.count}"

    data_hash.each do |row_data|
      properties = row_data['properties']
      region = API::V1::FindOrCreateRegion.call(properties.slice('region_en', 'region_cn', 'region_type'))
      point = GeometryPoint.create(region: region, geometry: RGeo::GeoJSON.decode(row_data).geometry)
    end
    puts "points count >> #{GeometryPoint.count}"
  end
end
