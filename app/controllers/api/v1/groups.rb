module API
	module V1
		class Groups < Grape::API
			include API::V1::Defaults
			include Grape::Rails::Cache

			resource :groups do
				desc "Return all groups"
				params do
					use :pagination
				end
				get "", root: :groups do
					groups = FetchGroup.new.all

					present groups, with: API::V1::Entities::Group
				end

				desc "Return a group"
				params do
					requires :id, type: String, desc: "ID / slug of the group"
				end
				get ":id", root: "group" do
          group = Group.find_by_id_or_slug!(permitted_params[:id])
					present group, with: API::V1::Entities::Group
				end

				desc "Return a group's subgroups"
				params do
					requires :id, type: String, desc: "ID / slug of the group"
					use :pagination
				end
				get ":id/subgroups" do
          group = Group.find_by_id_or_slug!(permitted_params[:id])
					subgroups = FetchSubgroup.new.by_group(group)
					present subgroups, with: API::V1::Entities::BasicSubgroup
				end

				desc "Return a group's subgroup by id"
				params do
					requires :id, type: String, desc: "ID / slug of the group"
					requires :subgroup_id, type: String, desc: "ID / slug of the subgroup"
				end
				get ":id/subgroups/:subgroup_id" do
          group = Group.find_by_id_or_slug!(permitted_params[:id])
					subgroup = Subgroup.find_by_id_or_slug!(permitted_params[:subgroup_id], group_id: group.id)
					present subgroup, with: API::V1::Entities::FullSubgroup
				end

				desc "Return subgroup indicators"
				params do
					requires :id, type: String, desc: "ID / slug of the group"
					requires :subgroup_id, type: String, desc: "ID / slug of the subgroup"
					use :pagination
				end
				get ":id/subgroups/:subgroup_id/indicators" do
          group = Group.find_by_id_or_slug!(permitted_params[:id])
          subgroup = Subgroup.find_by_id_or_slug!(permitted_params[:subgroup_id], group_id: group.id)
					indicators = FetchIndicator.new.by_subgroup(subgroup)
					present indicators, with: API::V1::Entities::FullIndicator
				end
				
				desc "Return subgroup indicator by id"
				params do
					requires :id, type: String, desc: "ID / slug of the group"
					requires :subgroup_id, type: String, desc: "ID / slug of the subgroup"
					requires :indicator_id, type: String, desc: "ID / slug of the indicator"
				end
				get ":id/subgroups/:subgroup_id/indicators/:indicator_id" do
          group = Group.find_by_id_or_slug!(permitted_params[:id])
          subgroup = Subgroup.find_by_id_or_slug!(permitted_params[:subgroup_id], group_id: group.id)
          indicator = Indicator.find_by_id_or_slug!(permitted_params[:indicator_id], {subgroup_id: subgroup.id}, [])
					present indicator, with: API::V1::Entities::FullIndicator
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
					use :pagination
				end
				get ":id/subgroups/:subgroup_id/indicators/:indicator_id/records" do
          group = Group.find_by_id_or_slug!(permitted_params[:id])
          subgroup = Subgroup.find_by_id_or_slug!(permitted_params[:subgroup_id], group_id: group.id)
          indicator = Indicator.find_by_id_or_slug!(permitted_params[:indicator_id], {subgroup_id: subgroup.id}, [])
					filter = FilterIndicatorRecords.new(indicator, params.slice(:category_1, :scenario, :region, :unit, :year, :start_year, :end_year))
					records = filter.call.includes(:widgets, :unit, :region, :scenario).order(year: :desc)
					#no need to order by year if there is only one year
					present records.page(params[:page]).per(params[:per_page]), with: API::V1::Entities::Record
				end
			end
		end
	end
end