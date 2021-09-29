module API
	module V1
		class Groups < Grape::API
			include API::V1::Defaults

			resource :groups do
				desc "Return all groups"
				params do
					use :pagination
				end
				get "", root: :groups do
					present Group.page(params[:page]).per(params[:per_page]).order(:name_en), with: API::V1::Entities::Group
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
					subgroups = Subgroup.
            where(group_id: group.id).
            order(:name_en).
            page(params[:page]).
            per(params[:per_page])
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
					indicators = Indicator.
            where(subgroup_id: subgroup.id).
            order(:name_en).
            page(params[:page]).
            per(params[:per_page])
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
					# optional :category_2, type: String, desc: "Name of the category"
					use :pagination
				end
				get ":id/subgroups/:subgroup_id/indicators/:indicator_id/records" do
          group = Group.find_by_id_or_slug!(permitted_params[:id])
          subgroup = Subgroup.find_by_id_or_slug!(permitted_params[:subgroup_id], group_id: group.id)
          indicator = Indicator.find_by_id_or_slug!(permitted_params[:indicator_id], {subgroup_id: subgroup.id}, [])
					if params[:category_1]
						records = Record.includes(:widgets, :unit, :region, :scenario).where(indicator_id: indicator.id).where(category_1: params[:category_1]).page(params[:page]).per(params[:per_page]).order(year: :desc)
					else
						records = Record.includes(:widgets, :unit, :region, :scenario).where(indicator_id: indicator.id).page(params[:page]).per(params[:per_page]).order(year: :desc)
					end
					present records, with: API::V1::Entities::Record
				end
			end
		end
	end
end