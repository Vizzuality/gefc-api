module API
  module V1
    class FileGenerator
      def initialize(records, file_format, current_locale)
        dir_path = "#{ENV["DOWNLOADS_PATH"]}"
        FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)

        @records = records
        @file_format = file_format
        @current_locale = current_locale
      end

      def call
        case @file_format
        when "csv"
          generate_csv
        when "xml"
          generate_xml
        else
          generate_json
        end
      end

      def generate_csv
        rejects = ["id", "created_at", "updated_at"]
        headers = Record.column_names.reject { |column_name| rejects.include?(column_name) }
        csv_data = CSV.generate do |csv_file|
          csv_file << headers
          @records&.each { |record| csv_file << record_to_row(record, rejects) }
        end

        csv_file_name = file_name
        File.write(csv_file_name, csv_data)

        csv_file_name
      end

      def generate_json
        rejects = ["id", "created_at", "updated_at"]
        id_to_slug = ["indicator_id", "unit_id", "region_id"]

        data_hash = {}
        data_hash["records"] = []
        @records.each do |record|
          record_attributes = {}
          record.attributes.each do |attr_name, attr_value|
            next if attr_name_dont_match_current_locale?(attr_name)
            unless rejects.include?(attr_name)
              if id_to_slug.include?(attr_name)
                record_attributes["indicator"] = record.indicator.name if attr_name == "indicator_id"
                record_attributes["unit"] = record.unit.name if attr_name == "unit_id"
                record_attributes["region"] = record.region.name if attr_name == "region_id"
              else
                record_attributes[attr_name] = attr_value
              end
            end
          end

          data_hash["records"].push(record_attributes)
        end
        json_file_name = file_name
        File.write(json_file_name, JSON.dump(data_hash))

        json_file_name
      end

      def generate_xml
        xml_encoding = {
          en: "UTF-8",
          cn: "ASCII-8BIT"
        }
        first_record = @records.first

        doc = Ox::Document.new
        instruct = Ox::Instruct.new(:xml)
        instruct[:version] = "1.0"
        instruct[:encoding] = xml_encoding[@current_locale]
        instruct[:standalone] = "yes"
        doc << instruct

        indicator = Ox::Element.new("indicator")
        indicator[:name] = first_record.indicator&.name_en
        doc << indicator

        @records.each do |record|
          record_to_xml = Ox::Element.new("record")

          rejects = ["id", "created_at", "updated_at"]

          record.attributes.each do |attr_name, attr_value|
            next if attr_name_dont_match_current_locale?(attr_name)

            unless rejects.include?(attr_name)
              unfrozen_attr_value = attr_value.to_s.dup

              if @current_locale == :cn
                if attr_value_chinese?(unfrozen_attr_value)
                  value_to_xml = Ox::Element.new(attr_name)

                  attr_value = attr_value.nil? ? "nil" : unfrozen_attr_value.force_encoding(xml_encoding[@current_locale])
                  value_to_xml << attr_value
                else
                  case attr_name
                  when "indicator_id"
                    attr_name = "indicator"
                    value_to_xml = if attr_value.nil?
                      attr_to_xml_node(attr_name, "nil")
                    else
                      attr_to_xml_node(attr_name, record.indicator.name_cn&.force_encoding(xml_encoding[@current_locale]))
                    end
                  when "unit_id"
                    attr_name = "unit"
                    value_to_xml = if attr_value.nil?
                      attr_to_xml_node(attr_name, "nil")
                    else
                      attr_to_xml_node(attr_name, record.unit.name&.force_encoding(xml_encoding[@current_locale]))
                    end
                  when "region_id"
                    attr_name = "region"
                    value_to_xml = if attr_value.nil?
                      attr_to_xml_node(attr_name, "nil")
                    else
                      attr_to_xml_node(attr_name, record.region.name_cn&.force_encoding(xml_encoding[@current_locale]))
                    end
                  else
                    value_to_xml = if attr_value.nil?
                      attr_to_xml_node(attr_name, "nil")
                    else
                      attr_to_xml_node(attr_name, unfrozen_attr_value.force_encoding(xml_encoding[@current_locale]))
                    end
                  end
                end
                record_to_xml << value_to_xml
              else
                unless attr_value_chinese?(unfrozen_attr_value)
                  case attr_name
                  when "indicator_id"
                    attr_name = "indicator"
                    value_to_xml = if attr_value.nil?
                      attr_to_xml_node(attr_name, "nil")
                    else
                      attr_to_xml_node(attr_name, record.indicator.name.force_encoding(xml_encoding[@current_locale]))
                    end
                  when "unit_id"
                    attr_name = "unit"
                    value_to_xml = if attr_value.nil?
                      attr_to_xml_node(attr_name, "nil")
                    else
                      attr_to_xml_node(attr_name, record.unit.name.force_encoding(xml_encoding[@current_locale]))
                    end
                  when "region_id"
                    attr_name = "region"
                    value_to_xml = if attr_value.nil?
                      attr_to_xml_node(attr_name, "nil")
                    else
                      attr_to_xml_node(attr_name, record.region.name.force_encoding(xml_encoding[@current_locale]))
                    end
                  else
                    value_to_xml = if attr_value.nil?
                      attr_to_xml_node(attr_name, "nil")
                    else
                      attr_to_xml_node(attr_name, unfrozen_attr_value.force_encoding(xml_encoding[@current_locale]))
                    end
                  end
                  record_to_xml << value_to_xml
                end
              end
            end
          end
          indicator << record_to_xml
        end

        xml = Ox.dump(doc)
        xml_file_name = file_name
        open(xml_file_name, "w:#{xml_encoding[@current_locale]}") do |io| # standard:disable Security/Open
          io.write(xml)
        end

        xml_file_name
      end

      def file_name
        indicator_name_en = @records.first.indicator.name_en
        name = "#{ENV["DOWNLOADS_PATH"]}#{Slugable.sanitize_name(indicator_name_en)}_#{DateTime.new.strftime("%FT%T%:z")}.#{@file_format}"
        puts name
        name
      end

      def attr_value_chinese?(string)
        string.scan(/\p{Han}/).count != 0
      end

      def attr_to_xml_node(name, value)
        value_to_xml = Ox::Element.new(name)
        value_to_xml << value
        value_to_xml
      end

      def attr_name_dont_match_current_locale?(attr_name)
        other_valid_locales = [:en, :cn]
        other_valid_locales.delete(@current_locale)
        attr_name.include?("_#{other_valid_locales.pop}")
      end

      def record_to_row(record, rejects)
        record_attributes_values = []
        id_to_slug = ["indicator_id", "unit_id", "region_id"]
        record.attributes.each do |attr_name, attr_value|
          unless rejects.include?(attr_name)
            if id_to_slug.include?(attr_name)
              record_attributes_values.push(record.indicator.name) if attr_name == "indicator_id"
              record_attributes_values.push(record.unit.name) if attr_name == "unit_id"
              record_attributes_values.push(record.region.name) if attr_name == "region_id"
            else
              record_attributes_values.push(attr_value) unless attr_name_dont_match_current_locale?(attr_name)
            end
          end
        end
        record_attributes_values
      end
    end
  end
end
