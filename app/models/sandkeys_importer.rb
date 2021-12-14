class SandkeysImporter
  # params: file_path, String.
  #
  def import_from_json(file_path)
    file = File.read(file_path)
    data_hash = JSON.parse!(file)
    puts "we are going to import #{data_hash.count} sandkeys"

    data_hash.each do |indicator_data|
      puts "indicator name >> #{indicator_data['indicator_en']}"

      # Indicator
      #
      current_indicator = Indicator.where(name_en: indicator_data['indicator_en']).first
      puts current_indicator.id

      current_sandkey = {
        "nodes" => indicator_data["nodes"],
        "data" => indicator_data["data"]
      }
      current_indicator.sandkey = current_sandkey
      current_indicator.save!
    end
  end
end
