class DataImporter
  def import(folder_path)
    puts "Starting full data import process..."

    puts "Importing groups..."
    GroupsImporter.new.import_from_folder(folder_path)
    puts "Groups imported"

    puts "Importing widgets..."
    WidgetsImporter.new.import_from_folder(folder_path)
    puts "Widgets imported"

    records = Dir.glob("#{folder_path}/sankey/*.json")
    records.each do |file_path|
      puts "Importing sankey..."
      SankeysImporter.new.import_from_json(file_path)
      puts "Sankey imported"
    end

    puts "Importing geometries..."
    GeometryImporter.new.import_from_folder(folder_path)
    puts "Geometries imported"

    puts "Populating extra indicator info..."
    IndicatorExtraInfo.new.populate
    puts "Extra indicator info populated"

    puts "Populating extra sankey metadata..."
    SankeyMeta.new.populate
    puts "Extra sankey metadata populated"

    puts "Populating extra region info..."
    RegionsExtraInfo.new.populate
    puts "Extra region info populated"
  end
end
