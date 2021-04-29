module API
	module V1
		class Health < Grape::API
			include API::V1::Defaults
			desc 'testing api.'
			get 'test' do
				{status: "ok"}
			end
		end
	end
end