require "bundler/gem_tasks"

begin
  require 'rspec/core'
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |spec|
    spec.pattern = FileList['spec/**/*_spec.rb']
    spec.rspec_opts = "-fs --color"
  end

  RSpec::Core::RakeTask.new(:"spec:integrations") do |spec|
    spec.pattern = FileList['spec/integrations/**/*_spec.rb']
    spec.rspec_opts = "-fs --color"
  end
  task :default => :spec
rescue LoadError
end


