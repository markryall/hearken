# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'hearken'

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

  s.post_install_message = <<EOF
Hey - thanks for installing hearken.

Before doing anything else, you should index your music collection by running:

  hearken_index path_to_your_music_collection

This could take a while if you have a large collection - you should hear some applause when it's done

After that just run hearken to start playing, queueing and rocking out.
EOF

  s.license = 'MIT'
  s.rubyforge_project = "hearken"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 1.9.2'

  s.add_dependency 'shell_shock', '~>0'
  s.add_dependency 'rainbow', '~> 2'
  s.add_dependency 'nokogiri', '~> 1'

  s.add_development_dependency 'rake', '~>0'
  s.add_development_dependency 'rspec', '~>3'
end
