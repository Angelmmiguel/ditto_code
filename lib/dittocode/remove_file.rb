module DittoCode

	@initialize = false

	module RemoveFile
		def if (environment)

			# check the env code
			unless @initialize
				DittoCode::Environments.check_env
			end

			if environment.split(",").include? ENV["DITTOCODE_ENV"]
				exit
			end 
		end

	end
end