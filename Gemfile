source "http://rubygems.org"
gemspec #:development_group => :test

# FIXME: This is redundant with the development dependencies in the Gemfile.
# Have to duplicate it here for Travis (?)
group :test do
  gem 'rake'
  gem 'rspec', '~> 2.0'
  gem 'fuubar'
end

group :development do
  gem 'yard'
  gem 'RedCloth' # <- needed for YARD; this will be problematic
  gem 'pry-byebug'
end
