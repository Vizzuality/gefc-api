require 'csv'

class GroupsImporter
  class InvalidFileException < StandardError; end

  # Creates a new Record in the db
  # for each row of the csv in the file_path.
  # params: file_path, String.
  #
  def import_from_csv(file_path)
    begin
      file_path = FileValidator.new(file_path).path
    rescue FileValidator::FileValidatorException => e
      handle_invalid_file_exception(e)
    end
    CSV.foreach(file_path, headers: true, converters: :numeric) do |row|
      row_data = row.to_hash.transform_keys! { |key| key.to_s.downcase }
      #puts row_data
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

  private
  # Checks if word is numeric.
  # params: word, String.
  #
  def numeric?(word)
    Float(word) != nil rescue false
  end
  # Loggs exception information.
  # Raises InvalidFileException.
  # params: e, error.
  #
  def handle_invalid_file_exception(e)
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")
    raise EmissionImporter::InvalidFileException.new(e.message)
  end
end
