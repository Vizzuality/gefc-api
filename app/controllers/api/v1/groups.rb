module API
  module V1
    class Groups < Grape::API
      use API::V1::APICacheBuster
      include API::V1::Defaults

      resource :groups do
        desc "Return all groups"
        params do
          use :pagination
        end
        get "", root: :groups do
          groups_collection = FetchGroup.new.all
          present groups_collection, with: API::V1::Entities::Group
        end

        desc "Return a group"
        params do
          requires :id, type: String, desc: "ID / slug of the group"
        end
        get ":id", root: "group" do
          group_object = FetchGroup.new.by_id_or_slug(permitted_params[:id])
          present group_object, with: API::V1::Entities::Group
        end

        desc "Return a group's subgroups"
        params do
          requires :id, type: String, desc: "ID / slug of the group"
          use :pagination
        end
        get ":id/subgroups" do
          group_object = FetchGroup.new.by_id_or_slug(permitted_params[:id])
          subgroups_collection = FetchSubgroup.new.by_group(group_object)
          present subgroups_collection, with: API::V1::Entities::BasicSubgroup
        end

        desc "Return a group's subgroup by id"
        params do
          requires :id, type: String, desc: "ID / slug of the group"
          requires :subgroup_id, type: String, desc: "ID / slug of the subgroup"
        end
        get ":id/subgroups/:subgroup_id" do
          # we are sending the indicators info here.
          # do we really need the /indicators and /indicators/:id ?
          subgroup_object = FetchSubgroup.new.by_id_or_slug(permitted_params[:subgroup_id], {})
          present subgroup_object, with: API::V1::Entities::FullSubgroup
        end

        desc "Return subgroup indicators"
        params do
          requires :id, type: String, desc: "ID / slug of the group"
          requires :subgroup_id, type: String, desc: "ID / slug of the subgroup"
          use :pagination
        end
        get ":id/subgroups/:subgroup_id/indicators" do
          subgroup_object = FetchSubgroup.new.by_id_or_slug(permitted_params[:subgroup_id], {})
          indicators_collection = FetchIndicator.new.by_subgroup(subgroup_object)
          present indicators_collection, with: API::V1::Entities::FullIndicator
        end

        desc "Return subgroup indicator by id"
        params do
          requires :id, type: String, desc: "ID / slug of the group"
          requires :subgroup_id, type: String, desc: "ID / slug of the subgroup"
          requires :indicator_id, type: String, desc: "ID / slug of the indicator"
        end
        get ":id/subgroups/:subgroup_id/indicators/:indicator_id" do
          indicator_object = FetchIndicator.new.by_id_or_slug(permitted_params[:indicator_id], {}, [])
          present indicator_object, with: API::V1::Entities::FullIndicator
        end

        desc "Return indicator records"
        params do
          requires :id, type: String, desc: "ID / slug of the group"
          requires :subgroup_id, type: String, desc: "ID / slug of the subgroup"
          requires :indicator_id, type: String, desc: "ID / slug of the indicator"
          optional :category_1, type: String, desc: "Name of the category"
          optional :scenario, type: String, desc: "UUID of the scenario"
          optional :region, type: String, desc: "UUID of the region"
          optional :unit, type: String, desc: "UUID of the region"
          optional :year, type: Integer, desc: "Year"
          optional :start_year, type: Integer, desc: "Start year"
          optional :end_year, type: Integer, desc: "End year"
          optional :visualization, type: String, desc: "Name of the widget"
          use :pagination
        end
        get ":id/subgroups/:subgroup_id/indicators/:indicator_id/records" do
          fetch_indicator = FetchIndicator.new
          indicator_object = fetch_indicator.by_id_or_slug(permitted_params[:indicator_id], {}, [])
          records_collection = fetch_indicator.records(indicator_object, params.slice(:category_1, :scenario, :region, :unit, :year, :start_year, :end_year, :visualization))
          present records_collection.page(params[:page]).per(params[:per_page]), with: API::V1::Entities::Record
        end
      end
    end
  end
end
