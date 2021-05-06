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
			end
		end
	end
end