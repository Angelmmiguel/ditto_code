require 'ditto_code'

print "I'm pro" if DittoCode::Exec.is 'PRO'
print "I'm pro or free" if DittoCode::Exec.is 'PRO,FREE'
print "I'm premium" if DittoCode::Exec.is 'PREMIUM'
print "I'm not premium" unless DittoCode::Exec.is 'PREMIUM'
print "I'm not premium nor pro" unless DittoCode::Exec.is 'PREMIUM,PRO'
