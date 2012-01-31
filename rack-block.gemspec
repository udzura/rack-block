# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rack/block/version"

Gem::Specification.new do |s|
  s.name        = "rack-block"
  s.version     = Rack::Block::VERSION
  s.authors     = ["Uchio Kondo"]
  s.email       = ["udzura@udzura.jp"]
  s.homepage    = "http://udzura.jp/rack-block"
  s.summary     = %q{A rack middleware for controlling accesses by search bot or not, remote ip address, etc.}
  s.description = %q{A rack middleware for controlling accesses by search bot or not, remote ip address, etc.}

  s.rubyforge_project = "rack-block"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "rack", '>= 1.3'

  #s.add_development_dependency "bundler", '~> 1.1.rc'
  s.add_development_dependency "pry"
  s.add_development_dependency "rake", '> 0'
  s.add_development_dependency "rspec", '>= 2'
  s.add_development_dependency "rack-test", '> 0'
  s.add_development_dependency "sinatra", '> 1.0'
  s.add_development_dependency "guard-rspec"
end
