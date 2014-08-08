module DittoCode

	@initialize = false

	module Exec

		# Exec the block of code if its environment
		# coincide with the global environment
		def self.if (environment)

			# check the env code
			unless @initialize
				DittoCode::Environments.check_env
			end

			if DittoCode::Environments.isIncluded? environment
				yield
			end 
		end

		# Return true if the environment defined in the line
		# coincide with the global environment. This function is 
		# used in conditional lines
		def self.is (environment)

			# check the env code
			unless @initialize
				DittoCode::Environments.check_env
			end

			if DittoCode::Environments.isIncluded? environment
				true
			else
				false
			end 

		end
	end
end