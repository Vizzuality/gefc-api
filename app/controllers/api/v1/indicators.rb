module API
	module V1
		class Indicators < Grape::API
			include API::V1::Defaults

			resource :indicators do
				desc "Return all indicators"
				get :indicators do
					present Indicator.all, with: API::V1::Entities::FullIndicator
				end
				desc "Return an indicator"
				params do
					requires :id, type: String, desc: "ID of the indicator"
				end
				get ":id", root: "indicator" do
					present Indicator.where(id: permitted_params[:id]).first!, with: API::V1::Entities::FullIndicator
				end
			end
		end
	end
end