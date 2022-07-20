module API
	module V1
		class Indicators < Grape::API
			use API::V1::APICacheBuster
			include API::V1::Defaults

			rescue_from IndicatorRegionException do |e|
				error!("#{e.message}", 404)
			end

			rescue_from SankeyException do |e|
				error!("#{e.message}", 404)
			end

			resource :indicators do
				desc "Return all indicators"
				get "" do
					fetch_indicator = FetchIndicator.new
					indicators_collection = fetch_indicator.all
					indicator_presenter = present indicators_collection, with: API::V1::Entities::FullIndicator
					indicators = indicator_presenter.to_json

					JSON.parse indicators
				end

				desc "Return an indicator"
				params do
					requires :id, type: String, desc: "ID / slug of the indicator"
				end
				get ":id", root: "indicator" do
					fetch_indicator = FetchIndicator.new
					indicator_object = fetch_indicator.by_id_or_slug(permitted_params[:id], {}, [])
					indicator_presenter = present indicator_object, with: API::V1::Entities::FullIndicator
					indicator = indicator_presenter.to_json

					JSON.parse indicator
				end

				desc "Return an indicator's records"
				params do
					requires :id, type: String, desc: "ID / slug of the indicator"
					optional :category_1, type: String, desc: "Name of the category"
					optional :start_year, type: Integer, desc: "Start year"
					optional :end_year, type: Integer, desc: "End year"
				end
				get ":id/records" do
					fetch_indicator = FetchIndicator.new
					indicator = fetch_indicator.by_id_or_slug(permitted_params[:id], {}, [])
					indicator_records = fetch_indicator.records(indicator, params.slice(:category_1, :scenario, :region, :unit, :year, :start_year, :end_year, :visualization))
					records_presenter = present indicator_records.page(params[:page]).per(params[:per_page]), with: API::V1::Entities::Record
					records = records_presenter.to_json

					JSON.parse records
				end

				desc "Return an indicator's meta"
				params do
					requires :id, type: String, desc: "ID / slug of the indicator"
				end
				get ":id/meta" do
					fetch_indicator = FetchIndicator.new
					indicator_object = fetch_indicator.by_id_or_slug(permitted_params[:id], {}, [])
					indicator_presenter = present indicator_object, with: API::V1::Entities::IndicatorMeta, :locale => permitted_params[:locale]
					indicator = indicator_presenter.to_json

					JSON.parse indicator
				end

				desc "Return an indicator's sandkey"
				params do
					requires :id, type: String, desc: "ID / slug of the indicator"
					optional :region, type: String, desc: "UUID of the region"
					optional :unit, type: String, desc: "UUID of the region"
					optional :year, type: Integer, desc: "Year"
				end
				get ":id/sandkey" do
					fetch_indicator = FetchIndicator.new
					indicator_object = fetch_indicator.by_id_or_slug(permitted_params[:id], {}, [])
					indicator_object.has_sankey?
					indicator_presenter = present indicator_object,
						with: API::V1::Entities::IndicatorSandkey,
						:locale => permitted_params[:locale],
						:year => permitted_params[:year],
						:unit => permitted_params[:unit],
						:region => permitted_params[:region]
					indicator = indicator_presenter.to_json

					JSON.parse indicator
				end
			end
		end
	end
end