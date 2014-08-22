require 'ditto_code'

DittoCode::Exec.if 'PRO' do
	
	a = 2
	b = true
	c = 5

	if a == 2 
		b = false
	end

	unless b 
		puts "I'm PRO"
	end

end

DittoCode::Exec.if 'PREMIUM' do

  a = 1..3
  b = true

  a.each do |item|
    puts "I'm PREMIUM"
  end  

  unless b 
    puts "I'm PRO"
  end

end