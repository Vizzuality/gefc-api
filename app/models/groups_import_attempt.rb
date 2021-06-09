class GroupsImportAttempt < ApplicationRecord

    after_create_commit :import_groups
    
    has_one_attached :original_file

    def import_groups
        file_path = ActiveStorage::Blob.service.path_for(original_file.key)
        CSV.foreach(file_path, headers: true, converters: :numeric) do |row|
            row_data = row.to_hash.transform_keys! { |key| key.to_s.downcase }
            current_group = Group.find_or_create_by(name: row_data["group"])
            current_subgroup = Subgroup.create_with(group: current_group).find_or_create_by(name: row_data["subgroup"]) 
            current_indicator = Indicator.create_with(subgroup: current_subgroup).find_or_create_by(name: row_data["indicator"])
            current_unit = Unit.find_or_create_by(name: row_data["units"])
            current_region = Region.create_with(region_type: row_data["region_type"]).find_or_create_by(name: row_data["region"])
            
            Record.create(indicator: current_indicator,
             category_1: row_data["category_1"], category_2: row_data["category_2"],
             region: current_region, unit: current_unit, value: row_data["value"], year: row_data["year"] )
        end

    end

end
