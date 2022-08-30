require "csv"

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
    clear_all
    puts "starting with #{Indicator.count} indicators."

    # Widgets:
    #
    widgets = {
      "pie" => API::V1::FindOrUpsertWidget.call(name: "pie"),
      "line" => API::V1::FindOrUpsertWidget.call(name: "line"),
      "bar" => API::V1::FindOrUpsertWidget.call(name: "bar"),
      "choropleth" => API::V1::FindOrUpsertWidget.call(name: "choropleth")
    }

    CSV.foreach(file_path, headers: true, converters: :numeric).with_index do |row, index|
      row_data = row.to_hash.transform_keys! { |key| key.to_s.downcase }
      next unless valid_row?(row_data, index)

      puts "row >> #{index + 2}"

      group_attributes = {name_en: row_data["group_en"], name_cn: row_data["group_cn"]}
      current_group = API::V1::FindOrUpsertGroup.call(group_attributes)
      subgroup_attributes = {name_en: row_data["subgroup_en"], name_cn: row_data["subgroup_cn"]}
      current_subgroup = API::V1::FindOrUpsertSubgroup.call(subgroup_attributes, current_group)
      indicator_attributes = {name_en: row_data["indicator_en"], name_cn: row_data["indicator_cn"]}
      current_indicator = API::V1::FindOrUpsertIndicator.call(indicator_attributes, current_subgroup)
      unit_name = row_data["units_en"]
      if unit_name.blank?
        puts "no unit here"
        current_unit = nil
      else
        current_unit = API::V1::FindOrUpsertUnit.call({name_en: unit_name})
      end

      region_attributes = {
        name_en: row_data["region_en"]&.strip,
        name_cn: row_data["region_cn"],
        region_type: row_data["region_type"]&.downcase&.split(" ")&.join("_")&.to_sym
      }
      current_region = API::V1::FindOrUpsertRegion.call(region_attributes)
      scenario_name = row_data["scenario_en"]
      current_scenario = if scenario_name.blank?
        nil
      else
        API::V1::FindOrUpsertScenario.call({name_en: scenario_name, name_cn: row_data["scenario_cn"]})
      end
      # Bulk is better.
      #
      if row_data["value"].nil? || row_data["value"].blank?
        puts "current group >> #{current_group.name_en}"
      else
        current_record = Record.create(
          indicator: current_indicator,
          category_1_en: row_data["category_1_en"],
          category_2_en: row_data["category_2_en"],
          category_3_en: row_data["category_3_en"],
          category_1_cn: row_data["category_1_cn"],
          category_2_cn: row_data["category_2_cn"],
          category_3_cn: row_data["category_3_cn"],
          region: current_region,
          unit: current_unit,
          value: row_data["value"],
          year: row_data["year"],
          scenario: current_scenario
        )
        puts "Records count >> #{Record.all.count}"
        puts "Records indicator >> #{current_indicator.slug}"

        widgets.keys.select { |k| row_data[k] == 1 }.each do |k|
          RecordWidget.create!(widget: widgets[k], record: current_record)
          # TO DO Shall be uniq
        end

        current_record.visualization_types = current_record.widgets_list
        current_record.save!

      end
    end
    puts "Records count >> #{Record.all.count}"
  end

  def clear_all
    Record.delete_all
    RecordWidget.delete_all
    Group.delete_all
    Subgroup.delete_all
    Indicator.delete_all
    Unit.delete_all
    Region.delete_all
    Scenario.delete_all
    Widget.delete_all
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

  # Validates that values with headers containing '_en' are not Chinesse characters.
  def valid_row?(row_data, index)
    english_columns = row_data.select { |key, value| key.include?("_en") }

    if english_columns.values.join("").gsub(/\s+/, "").scan(/\p{Han}/).count == 0
      true
    else
      puts "Error in row ##{index + 2} >> #{english_columns.values.join("|").gsub(/\s+/, "")}"
      false
    end
  end
end
