namespace :import do
  desc "Imports data from files in local file system."
  task all: :environment do
    groups_file_path = ENV['groups_file_path']
    ENV['file_path'] = groups_file_path; Rake::Task['groups:import_csv'].invoke if groups_file_path
    widgets_file_path = ENV['widgets_file_path']
    ENV['file_path'] = widgets_file_path; Rake::Task['widgets:import_json'].invoke if widgets_file_path
    points_file_path = ENV['points_file_path']
    ENV['file_path'] = points_file_path; Rake::Task['geometries:points:import_geojson'].invoke if points_file_path
    polygons_file_path = ENV['polygons_file_path']
    ENV['file_path'] = polygons_file_path; Rake::Task['geometries:polygons:import_geojson'].invoke if polygons_file_path
    sankeys_file_path = ENV['sankeys_file_path']
    ENV['file_path'] = sankeys_file_path; Rake::Task['sankeys:import_json'].invoke if sankeys_file_path
  end
  desc "Async Imports data from files in local file system."
  task all_async: :environment do
    groups_file_path = ENV['groups_file_path']
    ENV['file_path'] = groups_file_path; Rake::Task['groups:import_csv_async'].invoke if groups_file_path
    widgets_file_path = ENV['widgets_file_path']
    ENV['file_path'] = widgets_file_path; Rake::Task['widgets:import_json_async'].invoke if widgets_file_path
    points_file_path = ENV['points_file_path']
    ENV['file_path'] = points_file_path; Rake::Task['geometries:points:import_geojson_async'].invoke if points_file_path
    polygons_file_path = ENV['polygons_file_path']
    ENV['file_path'] = polygons_file_path; Rake::Task['geometries:polygons:import_geojson_async'].invoke if polygons_file_path
    sankeys_file_path = ENV['sankeys_file_path']
    ENV['file_path'] = sankeys_file_path; Rake::Task['sankeys:import_json_async'].invoke if sankeys_file_path
  end
  desc "Async. Populate extra info after import new dataset"
  task populate_extra_info_async: :environment do
    PopulateExtraInfoJob.perform_later
  end
end
