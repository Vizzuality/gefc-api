module API
	module V1
		class Indicators < Grape::API
			use API::V1::APICacheBuster
			include API::V1::Defaults

			rescue_from IndicatorRegionException do |e|
				error!("#{e.message}", 404)
			end

			resource :indicators do
				desc "Return all indicators"
				get "" do
					indicators = Rails.cache.fetch(['response', request.url]) do
						indicators_collection = Indicator.all
						indicator_presenter = present indicators_collection, with: API::V1::Entities::FullIndicator
						indicator_presenter.to_json
					end

					JSON.parse indicators
				end

				desc "Return an indicator"
				params do
					requires :id, type: String, desc: "ID / slug of the indicator"
				end
				get ":id", root: "indicator" do
					indicator = Rails.cache.fetch(['response', request.url]) do
							indicator_object = Indicator.find_by_id_or_slug!(permitted_params[:id], {}, [])
							indicator_presenter = present indicator_object, with: API::V1::Entities::FullIndicator
							indicator_presenter.to_json
					end

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
					records = Rails.cache.fetch(['response', request.url]) do
						fetch_indicator = FetchIndicator.new
						indicator = fetch_indicator.by_id_or_slug(permitted_params[:id], {}, [])
						records = fetch_indicator.records(indicator, params.slice(:category_1, :scenario, :region, :unit, :year, :start_year, :end_year, :visualization))
						records_presenter = present records.page(params[:page]).per(params[:per_page]), with: API::V1::Entities::Record
						records_presenter.to_json
					end

					JSON.parse records
				end

				desc "Return an indicator's meta"
				params do
					requires :id, type: String, desc: "ID / slug of the indicator"
				end
				get ":id/meta" do
					indicator = Rails.cache.fetch(['response', request.url]) do
						indicator_object = Indicator.find_by_id_or_slug!(permitted_params[:id], {}, [])
						indicator_presenter = present indicator_object, with: API::V1::Entities::IndicatorMeta, :locale => permitted_params[:locale]
						indicator_presenter.to_json
					end

					JSON.parse indicator
				end

				desc "Return an indicator's sandkey"
				params do
					requires :id, type: String, desc: "ID / slug of the indicator"
				end
				get ":id/sandkey" do
					indicator = Rails.cache.fetch(['response', request.url]) do
						indicator_object = Indicator.find_by_id_or_slug!(permitted_params[:id], {}, [])
						indicator_presenter = present indicator_object, with: API::V1::Entities::IndicatorSandkey, :locale => permitted_params[:locale]
						indicator_presenter.to_json
					end

					JSON.parse indicator
				end
			end
		end
	end
end