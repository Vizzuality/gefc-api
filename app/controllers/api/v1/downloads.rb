module API
	module V1
		class Downloads < Grape::API
			include API::V1::Defaults
			include API::V1::Authentication

			desc "Return csv"
			params do
				requires :id, type: String, desc: "ID / slug of the group"
				requires :subgroup_id, type: String, desc: "ID / slug of the subgroup"
				requires :indicator_id, type: String, desc: "ID / slug of the indicator"
			end
			get 'downloads' do

        if authenticate!
					byebug

					# group = Group.find_by_id_or_slug!(permitted_params[:id])
          # subgroup = Subgroup.find_by_id_or_slug!(permitted_params[:subgroup_id], group_id: group.id)
					# indicator = Indicator.find_by_id_or_slug!(permitted_params[:indicator_id], {subgroup_id: subgroup.id}, [])
					# records_collection = indicator.records
					records_collection = []

          generate_csv(records_collection)
          #send link to file
					content_type "application/octet-stream"
					header['Content-Disposition'] = "attachment; filename=mycsv.csv"
					env['api.format'] = :binary
					File.open(generate_csv, 'rb').read
        else
          error!({ :error_code => 401, :error_message => authenticate! }, 401)
        end
			end
		end
	end
end