class GeometryPolygonsImporter
  # @param file_path [String] absolute or relative to root
  def import_from_json(file_path)
    file = File.read(file_path)
    data_hash = JSON.parse!(file)['features']
    GeometryPolygon.delete_all
    puts "we are going to import #{data_hash.count} geometries if everything works fine"
    puts "polygons count >> #{GeometryPolygon.count}"

    data_hash.each do |row_data|
      properties = row_data['properties']
      region = API::V1::FindOrUpsertRegion.call(
        name_en: properties['region_en']&.strip,
        name_cn: properties['region_cn'],
        region_type: properties['region_type']&.downcase&.split(' ')&.join('_')&.to_sym
      )
      new_geometry = GeometryPolygon.create(region: region, geometry: RGeo::GeoJSON.decode(row_data).geometry)
      puts "new geometry created with id: #{new_geometry.id} for #{new_geometry.region.name}"
      puts "polygons count >> #{GeometryPolygon.count}"
    end
    puts "polygons count >> #{GeometryPolygon.count}"
  end
end
