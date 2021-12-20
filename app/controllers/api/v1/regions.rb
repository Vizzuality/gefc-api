module API
	module V1
		class Regions < Grape::API
			use API::V1::APICacheBuster
			include API::V1::Defaults

			rescue_from IndicatorRegionException do |e|
				error!("#{e.message}", 404)
			end

			resource :regions do
				desc "Return all regions"
				get "" do
					regions = Rails.cache.fetch(['response', request.url]) do
						regions = FetchRegion.new.all
					end

					present regions, with: API::V1::Entities::RegionWithGeometries
				end
				desc "Return a region"
				params do
					requires :id, type: String, desc: "ID of the region"
				end
				get ":id", root: "region" do
					region = Rails.cache.fetch(['response', request.url]) do
          	region = FetchRegion.new.by_id(permitted_params[:id])
					end

					present region, with: API::V1::Entities::RegionWithGeometries
				end
			end
		end
	end
end