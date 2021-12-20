module API
	module V1
		class Regions < Grape::API
			include API::V1::Defaults

			rescue_from IndicatorRegionException do |e|
				error!("#{e.message}", 404)
			end

			resource :regions do
				desc "Return all regions"
				get "" do
					regions = Rails.cache.fetch(['response', request.url]) do
						regions_collection = FetchRegion.new.all
						regions_presenter = present regions_collection, with: API::V1::Entities::RegionWithGeometries
						regions_presenter.to_json
					end

					JSON.parse regions
				end
				desc "Return a region"
				params do
					requires :id, type: String, desc: "ID of the region"
				end
				get ":id", root: "region" do
					region = Rails.cache.fetch(['response', request.url]) do
          	region_collection = FetchRegion.new.by_id(permitted_params[:id])
						region_presenter = present region_collection, with: API::V1::Entities::RegionWithGeometries
						region_presenter.to_json
					end

					JSON.parse region
				end
			end
		end
	end
end