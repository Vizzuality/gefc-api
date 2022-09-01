class WidgetsImporter
  def import_from_folder(folder_path)
    clear_all

    records = Dir.glob("#{folder_path}/*.json")
    records.each do |file_path|
      import_from_json(file_path)
    end

    puts "Data imported successfully"
  end

  def import_from_file(file_path)
    clear_all

    import_from_json(file_path)

    puts "Data imported successfully"
  end

  # TO DO Use the FileValidator and handle_invalid_file_exception
  #
  # Creates Group, Subgroup and Indicator in the db if they don't exist
  # for each element of the json in the file_path.
  # Sets Indicator.by_default.
  # Creates a relationship between Indicator and Widgets.
  # Sets Indicator.default_widget.
  # params: file_path, String.
  #
  def import_from_json(file_path)
    puts "Importing #{file_path}..."

    file = File.read(file_path)
    indicator_list = JSON.parse!(file)

    ActiveRecord::Base.transaction do
      indicator_list.each do |indicator_data|

        puts "Indicator name (English) #{indicator_data["indicator_en"]&.strip}"

        # Indicator
        group_attributes = { name_en: indicator_data["classification"]["group_en"]&.strip }
        current_group = API::V1::FindOrUpsertGroup.call(group_attributes)
        subgroup_attributes = { name_en: indicator_data["classification"]["subgroup_en"]&.strip }
        subgroup_attributes["by_default"] = indicator_data["classification"]["subgroup_default"] unless indicator_data["default"].nil?
        current_subgroup = API::V1::FindOrUpsertSubgroup.call(subgroup_attributes, current_group)
        indicator_attributes = {
          name_en: indicator_data["indicator_en"]&.strip,
          data_source_en: indicator_data["data_source_en"]&.strip,
          data_source_cn: indicator_data["data_source_cn"]&.strip,
          description_en: indicator_data["description_en"]&.strip,
          description_cn: indicator_data["description_cn"]&.strip,
          download_privilege: indicator_data["download_privilege"]
        }
        indicator_attributes["by_default"] = indicator_data["default"] unless indicator_data["default"].nil?
        current_indicator = API::V1::FindOrUpsertIndicator.call(indicator_attributes, current_subgroup)

        # Widgets
        indicator_data["widget"].each do |widget|
          by_default = (indicator_data["default_widget"]&.strip == widget)
          widget = API::V1::FindOrUpsertWidget.call(name: widget)
          API::V1::FindOrUpsertIndicatorWidget.call(
            indicator_id: current_indicator.id, widget_id: widget.id, by_default: by_default
          )
        end
      end
    end
  end

  def clear_all
    IndicatorWidget.delete_all
    reset_dictionaries
  end

  def reset_dictionaries
    API::V1::FindOrUpsertGroup.reload
    API::V1::FindOrUpsertSubgroup.reload
    API::V1::FindOrUpsertIndicator.reload
    API::V1::FindOrUpsertUnit.reload
    API::V1::FindOrUpsertRegion.reload
    API::V1::FindOrUpsertWidget.reload
    API::V1::FindOrUpsertIndicatorWidget.reload
  end
end
