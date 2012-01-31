source "http://rubygems.org"
gemspec #:development_group => :test

# FIXME: This is redundant with the development dependencies in the Gemfile.
# Have to duplicate it here for Travis (?)
group :test do
  gem 'rake'
  gem 'rspec', '~> 2.0'
end

group :development do
  gem 'ruby-debug', :platforms => :ruby_18
  gem 'ruby-debug19', :platforms => :ruby_19
  gem 'autotest-standalone'
  gem 'autotest-fsevent'
  gem 'autotest-growl'
end
