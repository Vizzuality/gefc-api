class GeometryImporter

  def import_from_folder(folder_path)
    geometry_files = Dir.glob("#{folder_path}/*.geojson")
    geometry_files.each do |file_path|
      import_from_json(file_path)
    end

    puts "Regions with geometries count: #{Region.where.not(geometry_encoded: nil).count}"
  end

  def import_from_json(file_path)
    puts "Importing #{file_path}..."
    file = File.read(file_path)
    geometries = JSON.parse!(file)["features"]

    ActiveRecord::Base.transaction do
      geometries.each do |geometry|
        properties = geometry["properties"]
        puts "Importing geometry for #{properties["region_en"]&.strip}"
        API::V1::FindOrUpsertRegion.call(
          {
            name_en: properties["region_en"]&.strip,
            name_cn: properties["region_cn"],
            region_type: properties["region_type"]&.downcase&.split(" ")&.join("_")&.to_sym,
            geometry: RGeo::GeoJSON.decode(geometry).geometry,
            tooltip_properties: properties["tooltip_properties"]
          }
        )
      end
    end
  end
end
