module API
	module V1
		class Downloads < Grape::API
			include API::V1::Defaults
			include API::V1::Authentication
			include API::V1::FileGenerator

			desc "Return csv"
			params do
				requires :id, type: String, desc: "ID / slug of the indicator"
				requires :file_format, type: String, desc: "file format, must be csv, json or xml"
				optional :category_1, type: String, desc: "Name of the category"
				optional :start_year, type: Integer, desc: "Start year"
				optional :end_year, type: Integer, desc: "End year"
			end
			get 'downloads' do
				
        if authenticate!
					indicator = Indicator.find_by_id_or_slug!(permitted_params[:id], {}, [])
					filter = FilterIndicatorRecords.new(indicator, params.slice(:category_1, :start_year, :end_year))
					records = filter.call.includes(:unit, :region)
					
					case permitted_params[:file_format]
					when "xml"
						if params[:locale] == 'cn'
							file_name = generate_xml_cn(records, I18n.locale)
						else
							file_name = generate_xml(records, I18n.locale)
						end
					when "csv"
						file_name = generate_csv(records, I18n.locale)
					else
						file_name = generate_json(records, I18n.locale)
					end

					content_type "application/octet-stream"
					header['Content-Disposition'] = "attachment; filename=#{file_name.split('/').last}"
					env['api.format'] = :binary
					File.open(file_name, 'rb').read
        else
          error!({ :error_code => 401, :error_message => authenticate! }, 401)
        end
			end
		end
	end
end