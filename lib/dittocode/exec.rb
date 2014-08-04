module DittoCode

	@initialize = false

	module Exec
		def self.if (environment)

			# check the env code
			unless @initialize
				check_env
			end

			if ENV["DITTOCODE_ENV"] == environment
				yield
			end 
		end

		private

		# Check the presence of the environment constant
		def check_env
			if ENV["DITTOCODE_ENV"].nil? || ENV["DITTOCODE_ENV"].empty?
				puts 'Ditto say -> Environment isn\'t declared'
			end
			@initialize = true
		end
	end

end