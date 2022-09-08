namespace :import do
  desc "Imports data from files in local file system."
  task all: :environment do

    Rake::Task["groups:import_csv_folder"].invoke
    Rake::Task["widgets:import_json_folder"].invoke
    ENV["file_name"] = "#{ENV["folder_name"]}/sankey/sankey.json"
    Rake::Task["sankeys:import_json"].invoke

    Rake::Task["indicators:populate_extra_info"].invoke
    Rake::Task["indicators:populate_meta"].invoke
    Rake::Task["indicators:populate_sankey_meta"].invoke


    ## TODO: configure these with the updated import stuff
    # points_file_name = ENV["points_file_name"]
    # ENV["file_name"] = points_file_name
    # Rake::Task["geometries:points:import_geojson"].invoke if points_file_name
    # polygons_file_name = ENV["polygons_file_name"]
    # ENV["file_name"] = polygons_file_name
    # Rake::Task["geometries:polygons:import_geojson"].invoke if polygons_file_name

    Rake::Task["regions:populate_extra_info"].invoke
  end
end
