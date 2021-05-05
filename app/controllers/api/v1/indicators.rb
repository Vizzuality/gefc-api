module API
	module V1
		class Indicators < Grape::API
			include API::V1::Defaults

			resource :indicators do
				desc "Return all indicators"
				get :indicators do
					Indicator.all
				end
			end
		end
	end
end