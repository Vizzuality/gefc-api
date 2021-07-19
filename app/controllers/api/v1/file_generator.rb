module API
	module V1
		module FileGenerator
			extend ActiveSupport::Concern
			require 'ox'

			included do
				helpers do
					#xml
					#
					def generate_xml_cn(records, current_locale)
						xml_encoding = {
							:cn => 'ASCII-8BIT'
						}
						doc = Ox::Document.new
						instruct = Ox::Instruct.new(:xml)
						instruct[:version] = '1.0'
						instruct[:encoding] = xml_encoding[current_locale]
						instruct[:standalone] = 'yes'
						doc << instruct
						indicator = Ox::Element.new('indicator')
						indicator[:name] = records.first.indicator&.name_cn
						doc << indicator

						records.each do  |record|
							record_to_xml = Ox::Element.new('record')
							record_attributes = {}
							rejects = ['id', 'created_at', 'updated_at']

							record.attributes.each do |attr_name, attr_value|
								next if not_locale?(attr_name, current_locale)
								
								unless rejects.include?(attr_name)
									unfrozen_attr_value = attr_value.to_s.dup
									if chinese?(unfrozen_attr_value) and current_locale != :en
										attr_name = attr_name
										value_to_xml = Ox::Element.new(attr_name)

										attr_value = (attr_value.nil?)? "nil" : unfrozen_attr_value.force_encoding(xml_encoding[current_locale])
										value_to_xml << attr_value
									else
										case attr_name
										when 'indicator_id'
											attr_name = 'indicator'
										when 'unit_id' 
											attr_name = 'unit'
										when 'region_id'
											attr_name = 'region'
										else
											attr_name = attr_name
										end

										value_to_xml = Ox::Element.new(attr_name)
										unless attr_value.nil?
											case attr_name
											when 'indicator'
												value_to_xml << record.indicator.name_cn&.force_encoding(xml_encoding[current_locale])
											when 'unit'
												value_to_xml << record.unit.name&.force_encoding(xml_encoding[current_locale])
											when 'region'
												value_to_xml << record.region.name_cn&.force_encoding(xml_encoding[current_locale])
											else
												value_to_xml << unfrozen_attr_value.force_encoding(xml_encoding[current_locale])
											end 
										else
											value_to_xml << "nil"
										end
									end
									record_to_xml << value_to_xml
								end
							end
							indicator << 	record_to_xml
							doc << indicator
						end

						xml = Ox.dump(doc)
						file_name = "#{Rails.root}/public/local_csv/foo_export.xml"
						open(file_name, "w:#{xml_encoding[current_locale]}") do |io|
							io.write(xml)
						end

						file_name
					end

					def generate_xml(records, current_locale)
						xml_encoding = {
							:en => 'UTF-8'
						}
						first_record = records.first
						
						doc = Ox::Document.new
						instruct = Ox::Instruct.new(:xml)
						instruct[:version] = '1.0'
						instruct[:encoding] = xml_encoding[current_locale]
						instruct[:standalone] = 'yes'
						doc << instruct

						indicator = Ox::Element.new('indicator')
						indicator[:name] = first_record.indicator&.name_en
						doc << indicator
						records.each do  |record|
							record_to_xml = Ox::Element.new('record')

							rejects = ['id', 'created_at', 'updated_at']
							record_attributes = {}
							record.attributes.each do |attr_name, attr_value|
								next if attr_name.include?('_cn')
								unless rejects.include?(attr_name)
									# remove freeze state
									unfrozen_attr_value = attr_value.to_s.dup
									if unfrozen_attr_value.scan(/\p{Han}/).count == 0
										case attr_name
										when 'indicator_id'
											attr_name = 'indicator'
										when 'unit_id' 
											attr_name = 'unit'
										when 'region_id'
											attr_name = 'region'
										else
											attr_name = attr_name
										end 
										value_to_xml = Ox::Element.new(attr_name)

										if attr_value.nil?
											value_to_xml << "nil"
										else
											case attr_name
											when 'indicator'
												value_to_xml << record.indicator.name.force_encoding(xml_encoding[current_locale])
											when 'unit' 
												value_to_xml << record.unit.name.force_encoding(xml_encoding[current_locale])
											when 'region'
												value_to_xml << record.region.name_en.force_encoding(xml_encoding[current_locale])
											else
												value_to_xml << unfrozen_attr_value.force_encoding(xml_encoding[current_locale])
											end 
										end
										record_to_xml << value_to_xml
									end
								end
							end
							indicator << record_to_xml
						end

						xml = Ox.dump(doc)
						file_name = "#{Rails.root}/public/local_csv/foo_export.xml"
						File.write(file_name, xml)

						file_name
					end

					# JSON
					#
					def generate_json(records, current_locale)
						rejects = ['id', 'created_at', 'updated_at']
						id_to_slug = ['indicator_id', 'unit_id', 'region_id']

						data_hash = {}
						data_hash['records'] = []
						records.each do |record|
							record_attributes = {}
							record.attributes.each do |attr_name, attr_value|
								next if not_locale?(attr_name, current_locale)
								unless rejects.include?(attr_name)
									if id_to_slug.include?(attr_name)
										record_attributes['indicator'] = record.indicator.name if attr_name == 'indicator_id'
										record_attributes['unit'] = record.unit.name if attr_name == 'unit_id'
										record_attributes['region'] = record.region.name if attr_name == 'region_id' 
									else
										record_attributes[attr_name] = attr_value 
									end
								end
							end

							data_hash['records'].push(record_attributes)
						end

						file_name = "#{Rails.root}/public/local_csv/foo_export.json"
						File.write(file_name, JSON.dump(data_hash))

						return file_name
					end

					# CSV
					#
					def generate_csv(records, current_locale)
						rejects = ['id', 'created_at', 'updated_at']
						headers = Record.column_names.reject { |column_name| rejects.include?(column_name)}
						new_csv = CSV.generate() do |csv_file|
							csv_file << headers
							records&.each { |record| csv_file << record_to_row(record, rejects, current_locale) }
						end

						file_name = "#{Rails.root}/public/local_csv/foo_export.csv"
						csv_data = new_csv

						File.write(file_name, csv_data)

						return file_name
					end

					def record_to_row(record, rejects, current_locale)
						record_attributes_values = []
						id_to_slug = ['indicator_id', 'unit_id', 'region_id']
								record.attributes.each do |attr_name, attr_value|
									unless rejects.include?(attr_name)
										if id_to_slug.include?(attr_name)
											record_attributes_values.push(record.indicator.name) if attr_name == 'indicator_id'
											record_attributes_values.push(record.unit.name) if attr_name == 'unit_id'
											record_attributes_values.push(record.region.name) if attr_name == 'region_id' 
										else
											record_attributes_values.push(attr_value) unless not_locale?(attr_name, current_locale) 
										end
									end
								end
						record_attributes_values
					end

					# common
					#
					def chinese?(string)
						string.scan(/\p{Han}/).count != 0
					end

					def not_locale?(attr_name, current_locale)
						other_valid_locales = [:en, :cn]
						other_valid_locales.delete(current_locale)
						attr_name.include?("_#{other_valid_locales.pop.to_s}")
					end
				end
			end
		end
	end
end