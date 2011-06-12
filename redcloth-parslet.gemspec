require File.expand_path("../lib/redcloth-parslet/version", __FILE__)

Gem::Specification.new do |s|
  # Gem name will be lower case starting in RedCloth 5!
  s.name        = "redcloth-parslet"
  s.version     = RedClothParslet::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jason Garber"]
  s.email       = ["jg@jasongarber.com"]
  s.homepage    = "http://github.com/jgarber/redcloth-parslet"
  s.summary     = "A rewrite of RedCloth in Parslet"
  s.description = "See RedCloth"

  s.required_rubygems_version = ">= 1.3.7"

  # lol - required for validation
  s.rubyforge_project         = "redcloth-parslet"

  # If you have other dependencies, add them here
  s.add_dependency "parslet", "~> 1.2"
  
  s.add_development_dependency 'rspec', "~> 2.0"
  s.add_development_dependency 'rake'

  # If you need to check in files that aren't .rb files, add them here
  s.files         = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.textile"]
  s.require_paths = ['lib']

  # If you need an executable, add it here
  # s.executables = ["redcloth"]

  # If you have C extensions, uncomment this line
  # s.extensions = "ext/extconf.rb"
end