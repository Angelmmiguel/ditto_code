Gem::Specification.new do |s|
  s.name        = 'ditto_code'
  s.version     = '0.2.3'
  s.date        = '2014-08-18'
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
  s.add_runtime_dependency "rainbow", ["= 2.0.0"] 

  # Test dependencies
  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-remote"
  s.add_development_dependency "pry-nav"
end