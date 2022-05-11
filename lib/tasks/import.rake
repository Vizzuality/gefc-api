namespace :import do
  desc "Imports data from files in local file system."
  task all: :environment do
    groups_file_name = ENV['groups_file_name']
    ENV['file_name'] = groups_file_name; Rake::Task['groups:import_csv'].invoke if groups_file_name
    widgets_file_name = ENV['widgets_file_name']
    ENV['file_name'] = widgets_file_name; Rake::Task['widgets:import_json'].invoke if widgets_file_name
    points_file_name = ENV['points_file_name']
    ENV['file_name'] = points_file_name; Rake::Task['geometries:points:import_geojson'].invoke if points_file_name
    polygons_file_name = ENV['polygons_file_name']
    ENV['file_name'] = polygons_file_name; Rake::Task['geometries:polygons:import_geojson'].invoke if polygons_file_name
  end
  desc "Async Imports data from files in local file system."
  task all_async: :environment do
    groups_file_name = ENV['groups_file_name']
    ENV['file_name'] = groups_file_name; Rake::Task['groups:import_csv'].invoke if groups_file_name
    widgets_file_name = ENV['widgets_file_name']
    ENV['file_name'] = widgets_file_name; Rake::Task['widgets:import_json'].invoke if widgets_file_name
    points_file_name = ENV['points_file_name']
    ENV['file_name'] = points_file_name; Rake::Task['geometries:points:import_geojson'].invoke if points_file_name
    polygons_file_name = ENV['polygons_file_name']
    ENV['file_name'] = polygons_file_name; Rake::Task['geometries:polygons:import_geojson'].invoke if polygons_file_name
  end
end
