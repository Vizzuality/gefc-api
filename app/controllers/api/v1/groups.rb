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
					fetch_group = FetchGroup.new
					groups_collection = fetch_group.all
					groups_presenter = present groups_collection, with: API::V1::Entities::Group
					groups = groups_presenter.to_json

					JSON.parse groups
				end

				desc "Return a group"
				params do
					requires :id, type: String, desc: "ID / slug of the group"
				end
				get ":id", root: "group" do
					fetch_group = FetchGroup.new
					group_object = fetch_group.by_id_or_slug(permitted_params[:id])
					group_presenter = present group_object, with: API::V1::Entities::Group
					group = group_presenter.to_json

					JSON.parse group
				end

				desc "Return a group's subgroups"
				params do
					requires :id, type: String, desc: "ID / slug of the group"
					use :pagination
				end
				get ":id/subgroups" do

					fetch_group = FetchGroup.new
					fetch_subgroup = FetchSubgroup.new
					group_object = fetch_group.by_id_or_slug(permitted_params[:id])
					subgroups_collection = fetch_subgroup.by_group(group_object)
					subgroups_presenter = present subgroups_collection, with: API::V1::Entities::BasicSubgroup
					subgroups = subgroups_presenter.to_json

					JSON.parse subgroups
				end

				desc "Return a group's subgroup by id"
				params do
					requires :id, type: String, desc: "ID / slug of the group"
					requires :subgroup_id, type: String, desc: "ID / slug of the subgroup"
				end
				get ":id/subgroups/:subgroup_id" do
					#we are sending the indicators info here.
					#do we really need the /indicators and /indicators/:id ?
					fetch_subgroup = FetchSubgroup.new
					subgroup_object = fetch_subgroup.by_id_or_slug(permitted_params[:subgroup_id], {})
					subgroup_presenter = present subgroup_object, with: API::V1::Entities::FullSubgroup
					subgroup = subgroup_presenter.to_json

					JSON.parse subgroup
				end

				desc "Return subgroup indicators"
				params do
					requires :id, type: String, desc: "ID / slug of the group"
					requires :subgroup_id, type: String, desc: "ID / slug of the subgroup"
					use :pagination
				end
				get ":id/subgroups/:subgroup_id/indicators" do
					fetch_subgroup = FetchSubgroup.new
					fetch_indicator = FetchIndicator.new
					subgroup_object = fetch_subgroup.by_id_or_slug(permitted_params[:subgroup_id], {})
					indicators_collection = fetch_indicator.by_subgroup(subgroup_object)
					indicators_presenter = present indicators_collection, with: API::V1::Entities::FullIndicator
					indicators = indicators_presenter.to_json

					JSON.parse indicators
				end
				
				desc "Return subgroup indicator by id"
				params do
					requires :id, type: String, desc: "ID / slug of the group"
					requires :subgroup_id, type: String, desc: "ID / slug of the subgroup"
					requires :indicator_id, type: String, desc: "ID / slug of the indicator"
				end
				get ":id/subgroups/:subgroup_id/indicators/:indicator_id" do
					fetch_indicator = FetchIndicator.new
					indicator_object = fetch_indicator.by_id_or_slug(permitted_params[:indicator_id], {}, [])
					indicator_presenter = present indicator_object, with: API::V1::Entities::FullIndicator
					indicator = indicator_presenter.to_json

					JSON.parse indicator
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
					records_presenter = present records_collection.page(params[:page]).per(params[:per_page]), with: API::V1::Entities::Record
					records = records_presenter.to_json

					JSON.parse records
				end
				
			end
		end
	end
end