class SankeysImporter
  # params: file_path, String.
  #
  def import_from_json(file_path)
    file = File.read(file_path)
    data_hash = JSON.parse!(file)
    puts "Importing #{data_hash.count} sankeys"

    data_hash.each do |indicator_data|
      puts "indicator name >> #{indicator_data["indicator_en"]}"

      # Indicator
      #
      current_indicator = Indicator.where(name_en: indicator_data["indicator_en"]).first
      puts current_indicator.id

      raise SankeyException.new('Sankey input data is missing the "data" property') if indicator_data["data"].nil?

      current_sankey = {
        "data" => indicator_data["data"]
      }
      current_indicator.sankey = current_sankey
      current_indicator.save!
    end
  end
end
