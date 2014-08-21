require 'spec_helper'

describe "dittoc" do 

	# Test to check execution of code with 1 environment
	describe 'Parse a file with inline conditionals and one environment (PRO)' do



	end

	# Multiple environments
	describe 'exec a block based on two environments (PRO,PREMIUM)' do


	end

	# Inline conditional
	describe 'Parse a file with inline conditionals based on one environment (PRO)' do

		it 'The outputs must coincide' do

			# Initiathe the env
			ENV["DITTOCODE_ENV"] = "PRO"

			# Parse the file
			`dittoc PRO spec/code_parser/inline_conditionals.rb`

			# Compare the outputs
			result = `bundle exec ruby spec/code_parser/inline_conditionals_PRO.rb`
			output = `bundle exec ruby spec/code_parser/inline_conditionals.rb`

			# Delete the file
			FileUtils.rm('spec/code_parser/inline_conditionals_PRO.rb')

			expect(result).to eq(output)

		end

	end

	# Multiple environments
	describe 'Parse a file witn inline conditionals based on two environments (PRO,PREMIUM)' do

		it 'The outputs must coincide' do

			# Initiathe the env
			ENV["DITTOCODE_ENV"] = "PRO,PREMIUM"

			# Parse the file
			`dittoc PRO,PREMIUM spec/code_parser/inline_conditionals.rb`

			# Compare the outputs
			result = `bundle exec ruby spec/code_parser/inline_conditionals_PRO,PREMIUM.rb`
			output = `bundle exec ruby spec/code_parser/inline_conditionals.rb`

			# Delete the file
			FileUtils.rm('spec/code_parser/inline_conditionals_PRO,PREMIUM.rb')

			expect(result).to eq(output)

		end

	end

end