module API
	module V1
		class Indicators < Grape::API
			include API::V1::Defaults

			rescue_from IndicatorRegionException do |e|
				error!("#{e.message}", 404)
			end

			resource :indicators do
				desc "Return all indicators"
				get "" do
					indicators = Rails.cache.fetch(['response', request.url]) do
							indicators = Indicator.includes(records: [:unit, :region, :widgets]).all
					end

					present indicators, with: API::V1::Entities::FullIndicator
				end

				desc "Return an indicator"
				params do
					requires :id, type: String, desc: "ID / slug of the indicator"
				end
				get ":id", root: "indicator" do
					indicator = Rails.cache.fetch(['response', request.url]) do
							indicator = Indicator.find_by_id_or_slug!(permitted_params[:id], {}, [])
					end

					present indicator, with: API::V1::Entities::FullIndicator
				end

				desc "Return an indicator's records"
				params do
					requires :id, type: String, desc: "ID / slug of the indicator"
					optional :category_1, type: String, desc: "Name of the category"
					optional :start_year, type: Integer, desc: "Start year"
					optional :end_year, type: Integer, desc: "End year"
				end
				get ":id/records" do
					records = Rails.cache.fetch(['response', request.url]) do
						indicator = Indicator.find_by_id_or_slug!(permitted_params[:id], {}, [])
						records = FetchIndicator.new.records(indicator, params.slice(:category_1, :scenario, :region, :unit, :year, :start_year, :end_year))
					end

					present records, with: API::V1::Entities::Record
				end
			end
		end
	end
end