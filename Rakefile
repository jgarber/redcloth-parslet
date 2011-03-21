require "bundler"
Bundler.setup

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)
task :default => :spec

gemspec = eval(File.read("redcloth-parslet.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["redcloth-parslet.gemspec"] do
  system "gem build redcloth-parslet.gemspec"
  system "gem install redcloth-parslet-#{RedClothParslet::VERSION}.gem"
end