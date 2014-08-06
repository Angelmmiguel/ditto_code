module DittoCode

	@initialize = false

	module HoldFile
		def self.if (environment)

			# check the env code
			unless @initialize
				DittoCode::Environments.check_env
			end

			unless DittoCode::Environments.isIncluded? environment
				exit
			end 
		end
		
	end
end