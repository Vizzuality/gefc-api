class EnergyBalanceImporter

  def import_from_json(file_path)
    puts "Importing #{file_path}..."

    file = File.read(file_path)
    energy_balance_data = JSON.parse!(file)

    records = []
    ActiveRecord::Base.transaction do
      energy_balance_data.each do |energy_balance_element|

        group_attributes = { name_en: energy_balance_element["group_en"]&.strip, name_cn: energy_balance_element["group_cn"]&.strip }
        current_group = API::V1::FindOrUpsertGroup.call(group_attributes)
        subgroup_attributes = { group_id: current_group.id, name_en: energy_balance_element["subgroup_en"]&.strip, name_cn: energy_balance_element["subgroup_cn"]&.strip }
        current_subgroup = API::V1::FindOrUpsertSubgroup.call(subgroup_attributes, current_group)
        indicator_attributes = { name_en: energy_balance_element["indicator_en"]&.strip, name_cn: energy_balance_element["indicator_cn"]&.strip, subgroup_id: current_subgroup.id }
        current_indicator = API::V1::FindOrUpsertIndicator.call(indicator_attributes)

        unless energy_balance_element["file_name"].empty?
          current_record = {
            id: SecureRandom.uuid,
            indicator_id: current_indicator.id,
            category_1_en: energy_balance_element["category_1_en"]&.strip,
            category_1_cn: energy_balance_element["category_1_cn"]&.strip,
            file: energy_balance_element["file_name"]
          }
          records.push(current_record)

        end
      end

      Record.insert_all(records) unless records.empty?
    end
  end
end
