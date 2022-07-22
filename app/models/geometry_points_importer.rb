class GeometryPointsImporter
  def import_from_multiple_json(file_path)
    GeometryPoint.delete_all
    all_json_files = Dir.entries(file_path).select { |e| File.extname(e) == ".geojson" }
    
    all_json_files.each do |file_name|
      full_file_path = file_path + "/" + file_name
      import_from_json(full_file_path)
    end
  end

  # @param file_path [String] absolute or relative to root
  # 
  def import_from_json(file_path)
    file = File.read(file_path)
    data_hash = JSON.parse!(file)['features']

    data_hash.each do |row_data|
      properties = row_data['properties']
      
      region = API::V1::FindOrUpsertRegion.call(
        name_en: properties['region_en']&.strip,
        name_cn: properties['region_cn'],
        region_type: properties['region_type']&.downcase&.split(' ')&.join('_')&.to_sym
      )
      
      GeometryPoint.create(region: region, geometry: RGeo::GeoJSON.decode(row_data).geometry, tooltip_properties: properties['tooltip_properties'])
    end
  end
end
