module Code
	
	def self.pro_environment

		DittoCode::Exec.if 'PRO' do
			"I'm pro"
		end

	end

	def self.pro_and_free_environment

		DittoCode::Exec.if 'PRO,FREE' do
			"I'm free and pro"
		end
	end

	def self.conditional_pro_environment

		"I'm pro" if DittoCode::Exec.is 'PRO'

	end

	def self.conditional_pro_and_free_environment

		"I'm free and pro" if DittoCode::Exec.is 'PRO,FREE'
	end

end