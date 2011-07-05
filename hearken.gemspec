# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hearken/version"

Gem::Specification.new do |s|
  s.name        = "hearken"
  s.version     = Hearken::VERSION
  s.authors     = ["Mark Ryall"]
  s.email       = ["mark@ryall.name"]
  s.homepage    = "http://github.com/markryall/hearken"
  s.summary     = "command line music player"
  s.description = <<EOF
A command line tool to enqueue and play music tracks.

This also extracts the tags from a collection of folders.

This replaces and combines the functionality from a couple of other gems (audio_library and songbirdsh).
EOF

  s.rubyforge_project = "hearken"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'thor', '~>0'
  s.add_dependency 'splat', '~>0'
  s.add_dependency 'shell_shock', '~>0'
  s.add_dependency 'simple_scrobbler', '~> 0'
  s.add_dependency 'rainbow', '~> 1'

  s.add_development_dependency 'rake', '~>0'
  s.add_development_dependency 'rspec', '~>2'
end
