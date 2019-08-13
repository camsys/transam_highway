source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Declare your gem's dependencies in transam_highway.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.

gem 'transam_core', git: "https://github.com/camsys/transam_core", branch: :quarter3
gem 'transam_spatial', git: "https://github.com/camsys/transam_spatial"
gem 'active_record-acts_as', git: 'https://github.com/camsys/active_record-acts_as', branch: 'master' # use our fork
gem 'mysql2', "~> 0.5.1" # lock gem for dummy app
gem 'activerecord-mysql2rgeo-adapter', git: 'https://github.com/camsys/activerecord-mysql2rgeo-adapter', branch: 'master'
gem "rgeo"
gem 'rgeo-geojson'
gem 'rgeo-proj4'

gem 'rack-test'
gem 'rails-controller-testing' # assigns has been extracted to this gem
gem 'responders' # get jbuilder working on Travis. It wasn't automatically rendering the json views.
gem 'byebug'
gem 'haml-rails', '~> 1.0' # generate haml views instead of erb views

gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]
