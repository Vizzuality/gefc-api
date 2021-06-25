require 'csv'

class GroupsImporter
  class InvalidFileException < StandardError; end

  # TO DO Use the FileValidator and handle_invalid_file_exception
  #
  # Creates a new Record in the db
  # for each row of the csv in the file_path.
  # Creates a relationship between Record and Widgets.
  # params: file_path, String.
  #
  def import_from_csv(file_path)
    puts "indicators count >> #{Indicator.count}"

    file_path = Rails.root.to_s + '/' + file_path
    CSV.foreach(file_path, headers: true, converters: :numeric) do |row|
      puts '...'
      row_data = row.to_hash.transform_keys! { |key| key.to_s.downcase }
      # DRY
      # Please, don't search each time.
      #
      current_group = Group.find_or_create_by(name: row_data["group_en"])
      current_subgroup = Subgroup.create_with(group: current_group).find_or_create_by(name: row_data["subgroup_en"]) 
      current_indicator = Indicator.create_with(subgroup: current_subgroup).find_or_create_by(name: row_data["indicator_en"])
      current_unit = Unit.find_or_create_by(name: row_data["units_en"])
      current_region = Region.create_with(region_type: row_data["region_type"]).find_or_create_by(name: row_data["region_en"])
      # Bulk is better.
      #
      current_record = Record.create(indicator: current_indicator,
       category_1: row_data["category_1_en"], category_2: row_data["category_2_en"],
       region: current_region, unit: current_unit, value: row_data["value"], year: row_data["year"] )
      
       puts "Records count >> #{Record.all.count}"
      # Widgets:
      #
      all_widgets = Widget.all
      record_widgets = {
        "pie" => row_data["pie"],
        "line" => row_data["line"],
        "bar" => row_data["bar"],
        "choropleth" => row_data["choropleth"]
      }

      record_widgets.select{ |k,v| v == "True" }.keys.each do |k|
        RecordWidget.create!(widget: Widget.find_or_create_by(name: k), record: current_record)
        # TO DO Shall be uniq
      end
    end
  end
end
