namespace :import do
  desc "Imports data from files in local file system."
  task all: :environment do

    Rake::Task["groups:import_csv_folder"].invoke
    Rake::Task["widgets:import_json_folder"].invoke

    records = Dir.glob("#{ENV["folder_name"]}/sankey/*.json")
    records.each do |file_path|
      ENV["file_name"] = file_path
      Rake::Task["sankeys:import_json"].invoke
    end

    Rake::Task["geometries:import_geojson"].invoke

    Rake::Task["indicators:populate_extra_info"].invoke
    Rake::Task["indicators:populate_sankey_meta"].invoke
    Rake::Task["regions:populate_extra_info"].invoke
  end
end
