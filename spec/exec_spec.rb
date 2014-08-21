require 'spec_helper'

describe "DittoCode::Exec blocks and inline conditionals" do 

	# Test to check execution of code with 1 environment
	describe 'exec a block based on one environment (PRO)' do

		it 'The gem must exec this code' do

			# Initiathe the env
			ENV["DITTOCODE_ENV"] = "PRO"

			result = Code.pro_environment

			expect(result).to eq("I'm pro")

		end

		it 'The gem musn\'t exec this code' do

			# Initiathe the env
			ENV["DITTOCODE_ENV"] = "FREE"

			result = Code.pro_environment

			expect(result).to eq(nil)

		end

	end

	# Multiple environments
	describe 'exec a block based on two environments (PRO,PREMIUM)' do

		it 'The gem must exec this code' do

			# Initiathe the env
			ENV["DITTOCODE_ENV"] = "PRO"
			result_pro = Code.pro_and_free_environment

			ENV["DITTOCODE_ENV"] = "FREE"
			result_free = Code.pro_and_free_environment

			expect(result_pro).to eq("I'm free or pro")
			expect(result_free).to eq("I'm free or pro")

		end

		it 'The gem musn\'t exec this code' do

			# Initiathe the env
			ENV["DITTOCODE_ENV"] = "PREMIUM"
			result = Code.pro_and_free_environment

			expect(result).to eq(nil)

		end

	end

	# Inline conditional
	describe 'exec a line based on one environment (PRO)' do

		it 'The gem must exec this line' do

			# Initiathe the env
			ENV["DITTOCODE_ENV"] = "PRO"

			result = Code.conditional_pro_environment

			expect(result).to eq("I'm pro")

		end

		it 'The gem musn\'t exec this line' do

			# Initiathe the env
			ENV["DITTOCODE_ENV"] = "FREE"

			result = Code.conditional_pro_environment

			expect(result).to eq("I'm not pro")

		end

	end

	# Multiple environments
	describe 'exec a line based on two environments (PRO,PREMIUM)' do

		it 'The gem must exec this line' do

			# Initiathe the env
			ENV["DITTOCODE_ENV"] = "PRO"
			result_pro = Code.conditional_pro_and_free_environment

			ENV["DITTOCODE_ENV"] = "FREE"
			result_free = Code.conditional_pro_and_free_environment

			ENV["DITTOCODE_ENV"] = "FREE,PRO"
			result_free_or_pro = Code.conditional_pro_and_free_environment

			expect(result_pro).to eq("I'm free or pro")
			expect(result_free).to eq("I'm free or pro")
			expect(result_free_or_pro).to eq("I'm free or pro")

		end

		it 'The gem musn\'t exec this line' do

			# Initiathe the env
			ENV["DITTOCODE_ENV"] = "PREMIUM"
			result = Code.conditional_pro_and_free_environment

			expect(result).to eq(nil)

		end

	end

end