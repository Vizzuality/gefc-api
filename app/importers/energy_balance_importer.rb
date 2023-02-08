class EnergyBalanceImporter

  def import_from_json(file_path)
    puts "Importing #{file_path}..."
    API::V1::EnergyBalance.new.upload_file(file_path)
  end
end
