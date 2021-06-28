class WidgetsImporter
  # TO DO Use the FileValidator and handle_invalid_file_exception
  #
  # Creates Group, Subgroup and Indicator  in the db if they don't exist
  # for each element of the json in the file_path.
  # Sets Indicator.by_default.
  # Creates a relationship between Indicator and Widgets.
  # Sets Indicator.default_widget.
  # params: file_path, String.
  #
  def import_from_json(file_path)
    file_path = Rails.root.to_s + '/' + file_path

    file = File.read(file_path)
    data_hash = JSON.parse(file)
    puts "we are going to import #{data_hash.count} indicators if everything works fine"

    data_hash.each do |indicator_data|
      puts "indicators count >> #{Indicator.count}"

      #DRY
      #
      current_group = Group.find_or_create_by(name: indicator_data["classification"]["group_en"])
      #unless current_group.present? and current_group.name = indicator_data["classification"]["group_en"]
      current_subgroup = Subgroup.create_with(group: current_group).find_or_create_by(name: indicator_data["classification"]["subgroup_en"], by_default: indicator_data["classification"]["subgroup_default"])
      current_indicator = Indicator.create_with(subgroup: current_subgroup).find_or_create_by(name: indicator_data["indicator_en"], by_default: indicator_data["default"])

      #Widgets
      #
      by_default_widget = Widget.find_or_create_by(name: indicator_data["default_widget"])
      IndicatorWidget.create(indicator: current_indicator, widget: by_default_widget, by_default: true)
      indicator_data["widget"].delete(indicator_data["default_widget"])
      
      indicator_data["widget"].each do |widget|
        IndicatorWidget.create(indicator: current_indicator, widget: Widget.find_or_create_by(name: widget))
      end
    end
  end
end
