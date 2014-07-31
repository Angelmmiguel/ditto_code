module DittoCode
	module Exec
		def self.if (environment)
			if ENV["DITTOCODE_ENV"] == environment
				yield
			end 
		end
	end
end