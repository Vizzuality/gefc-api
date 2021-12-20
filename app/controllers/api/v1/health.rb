module API
	module V1
		class Health < Grape::API
			use API::V1::APICacheBuster
			include API::V1::Defaults
			desc 'testing api.'
			get 'test' do
				{status: "ok"}
			end
		end
	end
end