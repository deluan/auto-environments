Gem::Specification.new do |s|
  s.name        = 'auto-environment'
  s.version     = '0.0.1'
  s.date        = '2013-10-25'
  s.summary     = "Auto provisions environments"
  s.description = "Uses Ansible to provision environments for your application"
  s.authors     = ["Deluan Quintao", "David McHoull"]
  s.email       = ['deluan@thoughtworks.com', 'dmchoull@thoughtworks.com']
  s.homepage    = 'https://github.com/deluan/auto-environments'
  s.license     = 'MIT'

  s.add_development_dependency "rspec", "~> 2.14.1"
  s.add_development_dependency "rspec-mocks", "~> 2.14.1"

  s.files         = Dir["./**/*"].reject { |file| (file =~ /\.\/(bin|log|pkg|script|spec|test|vendor)/) || (file =~ /\.gem$/) }
  s.test_files    = Dir["spec/**/*"]
  s.executables   = ['auto-environment']
end