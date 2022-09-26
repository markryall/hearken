# frozen_string_literal: true

require_relative "lib/hearken"

Gem::Specification.new do |spec|
  spec.name        = "hearken"
  spec.version     = Hearken::VERSION
  spec.authors     = ["Mark Ryall"]
  spec.email       = ["mark@ryall.name"]
  spec.homepage    = "http://github.com/markryall/hearken"
  spec.summary     = "command line music player"
  spec.description = <<~EOF
    A command line tool to enqueue and play music trackspec.

    This also extracts the tags from a collection of folderspec.

    This replaces and combines the functionality from a couple of other gems (audio_library and songbirdsh).
  EOF

  spec.post_install_message = <<~EOF
    Hey - thanks for installing hearken.

    Before doing anything else, you should index your music collection by running:

      hearken_index path_to_your_music_collection

    This could take a while if you have a large collection - you should hear some applause when it's done

    After that just run hearken to start searching for and then queueing tracks.
  EOF

  spec.required_ruby_version = ">= 2.6.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rainbow", "~> 2"
  spec.add_dependency "shell_shock"
  spec.metadata["rubygems_mfa_required"] = "true"
end
