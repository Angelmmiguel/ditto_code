module DittoCode

	@initialize = false

	module RemoveFile
		def self.if (environment)

			# check the env code
			unless @initialize
				DittoCode::Environments.check_env
			end

			if DittoCode::Environments.isIncluded? environment
				exit
			end 
		end

	end
end