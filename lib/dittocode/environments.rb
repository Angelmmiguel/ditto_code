module DittoCode

	module Environments

		# Check the presence of the environment constant
		def check_env
			if ENV["DITTOCODE_ENV"].nil? || ENV["DITTOCODE_ENV"].empty?
				puts 'Ditto say -> Environment isn\'t declared'
			end
			@initialize = true
		end

		# True if the environment is included
		def isIncluded? (environment)

			if environment.split(",").include? ENV["DITTOCODE_ENV"]
				true
			else
				false
			end
		end
	end
end