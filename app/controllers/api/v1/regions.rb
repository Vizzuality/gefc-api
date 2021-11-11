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
					regions = Region.all
					present regions, with: API::V1::Entities::RegionWithGeometries
				end
				desc "Return a region"
				params do
					requires :id, type: String, desc: "ID of the region"
				end
				get ":id", root: "region" do
					region = Region.find(permitted_params[:id])
					present region, with: API::V1::Entities::RegionWithGeometries
				end
			end
		end
	end
end