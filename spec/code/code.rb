module Code
  def self.pro_environment
    DittoCode::Exec.if 'PRO' do
      "I'm pro"
    end
  end

  def self.pro_and_free_environment
    DittoCode::Exec.if 'PRO,FREE' do
      "I'm free or pro"
    end
  end

  def self.conditional_pro_environment
    output = ''
    output += "I'm pro" if DittoCode::Exec.is 'PRO'
    output += "I'm not pro" unless DittoCode::Exec.is 'PRO'

    # return
    output
  end

  def self.conditional_pro_and_free_environment
    "I'm free or pro" if DittoCode::Exec.is 'PRO,FREE'
  end
end
