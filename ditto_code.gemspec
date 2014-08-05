Gem::Specification.new do |s|
  s.name        = 'ditto_code'
  s.version     = '0.1.5'
  s.date        = '2014-07-31'
  s.executables << 'dittoc'
  s.summary     = "ditto"
  s.description = "Transform your ruby code based on a custom variable."
  s.authors     = ["Angel M Miguel"]
  s.email       = 'angel@laux.es'
  s.files       = Dir['lib/**/*.rb','bin/*']
  s.homepage    =
    'https://github.com/Angelmmiguel/ditto_code'
  s.license       = 'MIT'
  s.add_runtime_dependency "indentation", ["= 0.1.1"]
end