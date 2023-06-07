class DataImporter
  def import(folder_path)
    puts "Starting full data import process..."

    puts "Clearing existing data"
    clear_all
    reset_dictionaries

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

    records = Dir.glob("#{folder_path}/energy_balance/*.json")
    records.each do |file_path|
      puts "Importing energy balance..."
      EnergyBalanceImporter.new.import_from_json(file_path)
      puts "Energy balance imported"
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

    reset_dictionaries
  end

  private

  def clear_all
    puts "Clearing data prior to import"
    RecordWidget.delete_all
    IndicatorWidget.delete_all
    ActiveRecord::Base.connection.execute("TRUNCATE records CASCADE")
    Indicator.delete_all
    Subgroup.delete_all
    Group.delete_all
    Unit.delete_all
    Region.delete_all
    Scenario.delete_all
    Widget.delete_all
    puts "Data cleared!"
  end

  def reset_dictionaries
    API::V1::FindOrUpsertGroup.reload
    API::V1::FindOrUpsertEntity.reload
    API::V1::FindOrUpsertIndicatorWidget.reload
    API::V1::FindOrUpsertScenario.reload
    API::V1::FindOrUpsertSubgroup.reload
    API::V1::FindOrUpsertIndicator.reload
    API::V1::FindOrUpsertUnit.reload
    API::V1::FindOrUpsertRegion.reload
    API::V1::FindOrUpsertWidget.reload
    puts "Dictionaries cleared!"
  end
end
