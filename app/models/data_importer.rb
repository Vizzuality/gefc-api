class DataImporter

  def import_from_compressed_file(file_path)
    geometry_files = Dir.glob("#{folder_path}/*.geojson")
    geometry_files.each do |file_path|
      import_from_json(file_path)
    end

    puts "Regions with geometries count: #{Region.where.not(geometry_encoded: nil).count}"
  end
end
