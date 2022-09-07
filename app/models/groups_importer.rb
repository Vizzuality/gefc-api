require "csv"

class GroupsImporter
  class InvalidFileException < StandardError; end

  def import_from_folder(folder_path)
    clear_all
    RecordWidget.skip_callback(:create, :after, :update_visualization_types)

    records = Dir.glob("#{folder_path}/*.csv")
    records.each do |file_path|
      import_from_csv(file_path)
    end

    RecordWidget.set_callback(:create, :after, :update_visualization_types)
    puts "Records count: #{Record.all.count}"
  end

  def import_from_file(file_path)
    clear_all
    RecordWidget.skip_callback(:create, :after, :update_visualization_types)

    import_from_csv(file_path)

    RecordWidget.set_callback(:create, :after, :update_visualization_types)
    puts "Records count: #{Record.all.count}"
  end

  private

  def create_widgets
    API::V1::FindOrUpsertWidget.call(name: "pie")
    API::V1::FindOrUpsertWidget.call(name: "line")
    API::V1::FindOrUpsertWidget.call(name: "bar")
    API::V1::FindOrUpsertWidget.call(name: "choropleth")
  end

  # TO DO Use the FileValidator and handle_invalid_file_exception
  #
  # Creates a new Record in the db
  # for each row of the csv in the file_path.
  # Creates a relationship between Record and Widgets.
  # params: file_path, String.
  def import_from_csv(file_path)
    puts "Importing #{file_path}..."

    ActiveRecord::Base.transaction do
      CSV.foreach(file_path, headers: true, converters: :numeric).with_index do |row, index|
        puts "Processing index #{index}..." if index % 100 == 0

        row_data = row.to_hash.transform_keys! { |key| key.to_s.downcase }
        next unless valid_row?(row_data, index)

        widgets = API::V1::FindOrUpsertWidget.all

        group_attributes = { name_en: row_data["group_en"]&.strip, name_cn: row_data["group_cn"]&.strip }
        current_group = API::V1::FindOrUpsertGroup.call(group_attributes)
        subgroup_attributes = { group_id: current_group.id, name_en: row_data["subgroup_en"]&.strip, name_cn: row_data["subgroup_cn"]&.strip }
        current_subgroup = API::V1::FindOrUpsertSubgroup.call(subgroup_attributes, current_group)
        indicator_attributes = { name_en: row_data["indicator_en"]&.strip, name_cn: row_data["indicator_cn"]&.strip, subgroup_id: current_subgroup.id }
        current_indicator = API::V1::FindOrUpsertIndicator.call(indicator_attributes)
        unit_name = row_data["units_en"]&.strip
        current_unit = if unit_name.blank?
                         nil
                       else
                         API::V1::FindOrUpsertUnit.call({ name_en: unit_name })
                       end

        region_attributes = {
          name_en: row_data["region_en"]&.strip,
          name_cn: row_data["region_cn"]&.strip,
          region_type: row_data["region_type"]&.strip&.downcase&.split(" ")&.join("_")&.to_sym
        }
        begin
          current_region = API::V1::FindOrUpsertRegion.call(region_attributes)
        rescue ArgumentError
          puts "Invalid region values: #{region_attributes.values.join("|")}"
          next
        end
        scenario_name = row_data["scenario_en"]&.strip
        current_scenario = if scenario_name.blank?
                             nil
                           else
                             API::V1::FindOrUpsertScenario.call({ name_en: scenario_name, name_cn: row_data["scenario_cn"]&.strip })
                           end
        # Bulk is better.
        #
        unless row_data["value"].nil? || row_data["value"].blank?
          current_record = Record.new(
            indicator: current_indicator,
            category_1_en: row_data["category_1_en"]&.strip,
            category_2_en: row_data["category_2_en"]&.strip,
            category_3_en: row_data["category_3_en"]&.strip,
            category_1_cn: row_data["category_1_cn"]&.strip,
            category_2_cn: row_data["category_2_cn"]&.strip,
            category_3_cn: row_data["category_3_cn"]&.strip,
            region: current_region,
            unit: current_unit,
            value: row_data["value"],
            year: row_data["year"],
            scenario: current_scenario,
            visualization_types: widgets.keys
          )

          widgets.keys.select { |k| row_data[k] == 1 }.each do |k|
            record_widget = RecordWidget.new(widget: widgets[k], record: current_record)
            record_widget.save!(validate: false) # skip id validation for belongs_to associated entities
          end

          current_record.save!
        end
      end
    end

  end

  def clear_all
    puts "Clearing data prior to import"
    RecordWidget.delete_all
    IndicatorWidget.delete_all
    Record.delete_all
    Indicator.delete_all
    Subgroup.delete_all
    Group.delete_all
    Unit.delete_all
    Region.delete_all
    Scenario.delete_all
    Widget.delete_all
    puts "Data cleared!"
    create_widgets
    reset_dictionaries
  end

  def reset_dictionaries
    API::V1::FindOrUpsertGroup.reload
    API::V1::FindOrUpsertSubgroup.reload
    API::V1::FindOrUpsertIndicator.reload
    API::V1::FindOrUpsertUnit.reload
    API::V1::FindOrUpsertRegion.reload
    API::V1::FindOrUpsertWidget.reload
  end

  # Validates that values with headers containing '_en' are not Chinese characters.
  def valid_row?(row_data, index)
    english_columns = row_data.select { |key, value| key.include?("_en") }

    if english_columns.values.join("").gsub(/\s+/, "").scan(/\p{Han}/).count == 0
      true
    else
      puts "Error in row ##{index + 2}: chinese characters found where only latin characters are expected >> #{english_columns.values.join("|").gsub(/\s+/, "")}"
      false
    end
  end
end
