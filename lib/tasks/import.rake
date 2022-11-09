namespace :import do
  desc "Imports data from files in local file system."
  task all: :environment do
    puts "Starting full data import process..."

    puts "Importing groups..."
    Rake::Task["groups:import_csv_folder"].invoke
    puts "Groups imported"

    puts "Importing widgets..."
    Rake::Task["widgets:import_json_folder"].invoke
    puts "Widgets imported"

    records = Dir.glob("#{ENV["folder_name"]}/sankey/*.json")
    records.each do |file_path|
      puts "Importing sankey..."
      ENV["file_name"] = file_path
      Rake::Task["sankeys:import_json"].invoke
      puts "Sankey imported"
    end

    puts "Importing geometries..."
    Rake::Task["geometries:import_geojson"].invoke
    puts "Geometries imported"

    puts "Populating extra indicator info..."
    Rake::Task["indicators:populate_extra_info"].invoke
    puts "Extra indicator info populated"

    puts "Populating extra sankey metadata..."
    Rake::Task["indicators:populate_sankey_meta"].invoke
    puts "Extra sankey metadata populated"

    puts "Populating extra region info..."
    Rake::Task["regions:populate_extra_info"].invoke
    puts "Extra region info populated"
  end
end
