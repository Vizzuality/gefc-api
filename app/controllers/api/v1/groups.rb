module API
	module V1
		class Groups < Grape::API
			include API::V1::Defaults

			resource :groups do
				desc "Return all groups"
				get "", root: :groups do
					present Group.all, with: API::V1::Entities::Group
				end

				desc "Return a group"
				params do
					requires :id, type: String, desc: "ID of the 
						group"
				end
				get ":id", root: "group" do
					present Group.where(id: permitted_params[:id]).first!, with: API::V1::Entities::Group
				end

				desc "Return a group subgroups"
				params do
					requires :id, type: String, desc: "ID of the group"
				end
				get ":id/subgroups" do
					present Subgroup.where(group_id: permitted_params[:id]), with: API::V1::Entities::BasicSubgroup
				end

				desc "Return a group subgroup by id"
				params do
					requires :id, type: String, desc: "ID of the group"
					requires :subgroup_id, type: String, desc: "ID of the subgroup"
				end
				get ":id/subgroups/:subgroup_id" do
					present Subgroup.find(permitted_params[:subgroup_id]), with: API::V1::Entities::FullSubgroup
				end

				desc "Return subgroup indicators"
				params do
					requires :id, type: String, desc: "ID of the group"
					requires :subgroup_id, type: String, desc: "ID of the subgroup"
				end
				get ":id/subgroups/:subgroup_id/indicators" do
					present Indicator.where(subgroup_id: permitted_params[:subgroup_id]), with: API::V1::Entities::FullIndicator
				end
				
				desc "Return subgroup indicator by id"
				params do
					requires :id, type: String, desc: "ID of the group"
					requires :subgroup_id, type: String, desc: "ID of the subgroup"
					requires :indicator_id, type: String, desc: "ID of the indicator"
				end
				get ":id/subgroups/:subgroup_id/indicators/:indicator_id" do
					present Indicator.find(permitted_params[:indicator_id]), with: API::V1::Entities::FullIndicator
				end

				desc "Return indicator records"
				params do
					requires :id, type: String, desc: "ID of the group"
					requires :subgroup_id, type: String, desc: "ID of the subgroup"
					requires :indicator_id, type: String, desc: "ID of the indicator"
					optional :category_1, type: String, desc: "Name of the category"
					# optional :category_2, type: String, desc: "Name of the category"
				end
				get ":id/subgroups/:subgroup_id/indicators/:indicator_id/records" do
					if params[:category_1]
						records = Record.where(indicator_id: permitted_params[:id]).where(category_1: params[:category_1])
					else
						records = Record.where(indicator_id: permitted_params[:id])
					end
					present records, with: API::V1::Entities::Record
				end
			end
		end
	end
end