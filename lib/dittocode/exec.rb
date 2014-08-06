module DittoCode

	@initialize = false

	module Exec
		def self.if (environment)

			# check the env code
			unless @initialize
				DittoCode::Environments.check_env
			end

			if DittoCode::Environments.isIncluded? environment
				yield
			end 
		end

	end
end