$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "transam_highway/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "transam_highway"
  s.version     = TransamHighway::VERSION
  s.authors     = ["mathmerized"]
  s.email       = ["mathmerized@gmail.com"]
  s.homepage    = "http://www.camsys.com"
  s.summary     = "Extension for TransAM."
  s.description = "Extension for TransAM."
  s.license     = "MIT"

  # Controls the order that engines are loaded for dependencies. transam_core is 1. 40 is a reasonable default for now.
  s.metadata = { "load_order" => "40" }

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 5.2"

  s.add_dependency 'rails-data-migrations'

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_bot_rails"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "mysql2"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "simplecov"
  s.add_development_dependency 'haml-rails'

end
