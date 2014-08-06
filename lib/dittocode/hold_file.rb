module DittoCode

	@initialize = false

	module HoldFile
		def if (environment)

			# check the env code
			unless @initialize
				DittoCode::Environments.check_env
			end

			unless environment.split(",").include? ENV["DITTOCODE_ENV"]
				exit
			end 
		end
		
	end
end