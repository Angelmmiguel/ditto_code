module DittoCode

	@initialize = false

	module Exec
		def if (environment)

			# check the env code
			unless @initialize
				DittoCode::Environments.check_env
			end

			if environment.split(",").include? ENV["DITTOCODE_ENV"]
				yield
			end 
		end

	end
end