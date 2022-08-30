module API
  module V1
    class Regions < Grape::API
      use API::V1::APICacheBuster
      include API::V1::Defaults

      rescue_from IndicatorRegionException do |e|
        error!(e.message.to_s, 404)
      end

      resource :regions do
        desc "Return all regions"
        get "" do
          regions_collection = FetchRegion.new.all
          present regions_collection, with: API::V1::Entities::RegionWithGeometries
        end
        desc "Return a region"
        params do
          requires :id, type: String, desc: "ID of the region"
        end
        get ":id", root: "region" do
          region_collection = FetchRegion.new.by_id(permitted_params[:id])
          present region_collection, with: API::V1::Entities::RegionWithGeometries
        end
      end
    end
  end
end
