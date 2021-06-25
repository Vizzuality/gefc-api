module API
	module V1
		class Indicators < Grape::API
			include API::V1::Defaults

			resource :indicators do
				desc "Return all indicators"
				get :indicators do
					indicators = Indicator.includes(records: [:unit, :region]).all
					present indicators, with: API::V1::Entities::FullIndicator
				end
				desc "Return an indicator"
				params do
					requires :id, type: String, desc: "ID of the indicator"
				end
				get ":id", root: "indicator" do
					indicator = Indicator.includes(records: [:unit, :region]).first
					present indicator, with: API::V1::Entities::FullIndicator
				end

				desc "Return an indicator's records"
				params do
					requires :id, type: String, desc: "ID of the indicator"
					optional :category_1, type: String, desc: "Name of the category"
					optional :start_year, type: Integer, desc: "Start year"
					optional :end_year, type: Integer, desc: "End year"
				end
				get ":id/records" do
					filter = FilterIndicatorRecords.new(permitted_params[:id], params.slice(:category_1, :start_year, :end_year))
					records = filter.call.includes(:unit, :region)

					present records, with: API::V1::Entities::Record
				end
			end
		end
	end
end