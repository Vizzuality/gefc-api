module API
	module V1
		# class ApiCacheBuster < Grape::Middleware::Base
    #   def after
    #     @app_response[1]["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    #     @app_response[1]["Pragma"] = "no-cache"
    #     @app_response[1]["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    #     @app_response
    #   end
    # end
		class Health < Grape::API
			use API::V1::APICacheBuster

			include API::V1::Defaults
			desc 'testing api.'
			get 'test' do
				#cache_control :no_cache
				# header['Surrogate-Control'] = 1.year.to_s
				# header['Cache-Control'] = 'public,max-age=900,stale-while-revalidate=1600'
				{status: "ok"}
			end
		end
	end
end