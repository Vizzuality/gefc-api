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
    clear_all
    puts "indicators count >> #{Indicator.count}"

    # Widgets:
    #
    widgets = {
      'pie' => API::V1::FindOrUpsertWidget.call(name: 'pie'),
      'line' => API::V1::FindOrUpsertWidget.call(name: 'line'),
      'bar' => API::V1::FindOrUpsertWidget.call(name: 'bar'),
      'choropleth' => API::V1::FindOrUpsertWidget.call(name: 'choropleth')
    }

    CSV.foreach(file_path, headers: true, converters: :numeric) do |row|
      row_data = row.to_hash.transform_keys! { |key| key.to_s.downcase }

      group_attributes = {name_en: row_data['group_en'], name_cn: row_data['group_cn']}
      current_group = API::V1::FindOrUpsertGroup.call(group_attributes)
      subgroup_attributes = {name_en: row_data['subgroup_en'], name_cn: row_data['subgroup_cn']}
      current_subgroup = API::V1::FindOrUpsertSubgroup.call(subgroup_attributes, current_group)
      indicator_attributes = {name_en: row_data['indicator_en'], name_cn: row_data['indicator_cn']}
      current_indicator = API::V1::FindOrUpsertIndicator.call(indicator_attributes, current_subgroup)
      current_unit = API::V1::FindOrUpsertUnit.call({name_en: row_data['units_en']})
      region_attributes = {
        name_en: row_data['region_en']&.strip,
        name_cn: row_data['region_cn'],
        region_type: row_data['region_type']&.downcase&.split(' ')&.join('_')&.to_sym
      }
      current_region = API::V1::FindOrUpsertRegion.call(region_attributes)
      # Bulk is better.
      #
      current_record = Record.create(
        indicator: current_indicator,
        category_1_en: row_data['category_1_en'],
        category_2_en: row_data['category_2_en'],
        category_3_en: row_data['category_3_en'],
        category_1_cn: row_data['category_1_cn'],
        category_2_cn: row_data['category_2_cn'],
        category_3_cn: row_data['category_3_cn'],
        region: current_region,
        unit: current_unit,
        value: row_data['value'],
        year: row_data['year']
      )

      widgets.keys.select{ |k| row_data[k]&.upcase == 'TRUE' }.each do |k|
        RecordWidget.create!(widget: widgets[k], record: current_record)
        # TO DO Shall be uniq
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
end
