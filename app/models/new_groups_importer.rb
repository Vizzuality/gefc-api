require 'csv'

class NewGroupsImporter
  class InvalidFileException < StandardError; end

  # TO DO Use the FileValidator and handle_invalid_file_exception
  # TO DO Create a relatioship between indicator and regions
  # TO DO Create a relatioship between indicator and units
  # TO DO add a condition to check if we want to clear all
  #
  # Creates a new Record in the db
  # for each row of the csv in the file_path.
  # Creates a relationship between Record and Widgets.
  # params: file_path, String.
  #
  def import_from_csv(file_path)
    #
    clear_all
    starting_time = Time.now
    puts "starting with #{Indicator.count} indicators."

    # Widgets:
    #
    widgets = {
      'pie' => API::V1::FindOrUpsertWidget.call(name: 'pie'),
      'line' => API::V1::FindOrUpsertWidget.call(name: 'line'),
      'bar' => API::V1::FindOrUpsertWidget.call(name: 'bar'),
      'choropleth' => API::V1::FindOrUpsertWidget.call(name: 'choropleth'),
      'sankey' => API::V1::FindOrUpsertWidget.call(name: 'sankey')
    }

    # Reading the csv to get all Units and Region
    units_hash = {}
    regions_hash = {}
    CSV.foreach(file_path, headers: true, converters: :numeric).with_index do |row, index|

      row_data = row.to_hash.transform_keys! { |key| key.to_s.downcase }
      if units_hash[row_data['units_en']].nil?
        units_hash[row_data['units_en']] = {name_en: row_data['units_en'], name_cn: row_data['units_cn']}
      end
      
      if regions_hash[row_data['region_en']].nil?
        regions_hash[row_data['region_en']] = {name_en: row_data['region_en'], name_cn: row_data['region_cn'], name_cn: row_data['region_type']}
      end
    end

    units_collection = {}
    units_hash.each do |key, value|
      current_unit = API::V1::FindOrUpsertUnit.call({name_en: value[:name_en], name_cn: value[:name_cn]})
      units_collection[value[:name_en]] = current_unit
    end

    regions_collection = {}
    regions_hash.each do |key, value|
      region_attributes = {
        name_en: value[:name_en]&.strip,
        name_cn: value[:name_cn],
        region_type: value[:region_type]&.downcase&.split(' ')&.join('_')&.to_sym
      }
      current_region = API::V1::FindOrUpsertRegion.call(region_attributes)
      regions_collection[value[:name_en]] = current_region
    end

    
    # Reading the csv to get all Groups
    groups_hash = {}
    CSV.foreach(file_path, headers: true, converters: :numeric).with_index do |row, index|

      row_data = row.to_hash.transform_keys! { |key| key.to_s.downcase }
      # next unless valid_row?(row_data, index)
      
      unless groups_hash[row_data['group_en']].nil?
        groups_hash[row_data['group_en']][:rows].push(index)
      end
      groups_hash[row_data['group_en']] = {name_en: row_data['group_en'], name_cn: row_data['group_cn'], rows: [index]} if groups_hash[row_data['group_en']].nil?
    end

    groups_collection = {}
    groups_hash.each do |key, value|
      group_attributes = {name_en: value[:name_en], name_cn: value[:name_cn]}
      current_group = API::V1::FindOrUpsertGroup.call(group_attributes)
      value[:group_id] = current_group.id
      groups_collection[current_group.id] = current_group
    end

    # puts groups_hash

    #read subgroups
    #save them into collection with rows
    subgroups_hash = {}
    groups_hash.each do |key, value|
      CSV.foreach(file_path, headers: true, converters: :numeric).with_index do |row, index|
        if value[:rows].include?(index)
          row_data = row.to_hash.transform_keys! { |key| key.to_s.downcase }
          unless subgroups_hash[row_data['subgroup_en']].nil?
            subgroups_hash[row_data['subgroup_en']][:rows].push(index)
          end
          subgroups_hash[row_data['subgroup_en']] = {name_en: row_data['subgroup_en'], name_cn: row_data['subgroup_cn'], group_id: value[:group_id], rows: [index]} if subgroups_hash[row_data['subgroup_en']].nil?
        end
      end
    end

    subgroups_collection = {}
    subgroups_hash.each do |key, value|
      current_group = groups_collection[value[:group_id]]
      subgroup_attributes = {name_en: value[:name_en], name_cn: value[:name_cn]}
      current_subgroup = API::V1::FindOrUpsertSubgroup.call(subgroup_attributes, current_group)
      value[:subgroup_id] = current_subgroup.id
      subgroups_collection[current_subgroup.id] = current_subgroup
    end

    #read indicators
    #save them into a collection with rows
    indicators_hash = {}
    
    subgroups_hash.each do |key, value|
      CSV.foreach(file_path, headers: true, converters: :numeric).with_index do |row, index|
        if value[:rows].include?(index)
          row_data = row.to_hash.transform_keys! { |key| key.to_s.downcase }
          unless indicators_hash[row_data['indicator_en']].nil?
            indicators_hash[row_data['indicator_en']][:rows].push(index)
          else
            indicators_hash[row_data['indicator_en']] = {name_en: row_data['indicator_en'], name_cn: row_data['indicator_cn'], subgroup_id: value[:subgroup_id], rows: [index]}
          end
        end
      end
    end

    indicators_collection = {}
    indicators_hash.each do |key, value|
      current_subgroup = subgroups_collection[value[:subgroup_id]]
      indicator_attributes = {name_en: value[:name_en], name_cn: value[:name_cn]}
      current_indicator = API::V1::FindOrUpsertIndicator.call(indicator_attributes, current_subgroup)
      value[:indicator_id] = current_indicator.id
      indicators_collection[current_indicator.id] = current_indicator
    end

    # read the csv and create records for each indicator
    indicators_hash.each do |key, value|
      CSV.foreach(file_path, headers: true, converters: :numeric).with_index do |row, index|
        if value[:rows].include?(index)
          row_data = row.to_hash.transform_keys! { |key| key.to_s.downcase }

          scenario_name = row_data['scenario_en']
          if scenario_name.blank?
            current_scenario = nil
          else
            current_scenario = API::V1::FindOrUpsertScenario.call({name_en: scenario_name, name_cn: row_data['scenario_cn']})
          end

          unless row_data['value'].nil? or row_data['value'].blank?
            current_record = Record.create(
              indicator: indicators_collection[value[:indicator_id]],
              category_1_en: row_data['category_1_en'],
              category_2_en: row_data['category_2_en'],
              category_3_en: row_data['category_3_en'],
              category_1_cn: row_data['category_1_cn'],
              category_2_cn: row_data['category_2_cn'],
              category_3_cn: row_data['category_3_cn'],
              region: regions_collection[row_data['region_en']],
              unit: units_collection[row_data['units_en']],
              value: row_data['value'],
              year: row_data['year'],
              scenario: current_scenario
            )

            widgets.keys.select{ |k| row_data[k] == 1 }.each do |k|
              RecordWidget.create!(widget: widgets[k], record: current_record)
            end
            
            current_record.visualization_types = current_record.widgets_list
            current_record.save!
          end
        end
      end
    end

    puts "it toke >> #{Time.now - starting_time}"
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
  # def valid_row?(row_data, index)
  #   english_columns = row_data.select{ |key, value| key.include?('_en') }

  #   unless english_columns.values.join('').gsub(/\s+/, "").scan(/\p{Han}/).count == 0
  #     puts "Error in row ##{index + 2} >> #{english_columns.values.join('|').gsub(/\s+/, "")}" 
  #     return false
  #   else
  #     return true
  #   end
  # end
end
