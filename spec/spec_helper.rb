require "bundler"
Bundler.setup

require "rspec"
require "redcloth-parslet"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.include RedClothParslet::Spec::Matchers
end
