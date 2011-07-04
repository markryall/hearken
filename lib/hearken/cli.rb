require 'thor'

require 'hearken/version'

module Hearken
  class Cli < Thor
    desc 'version', 'Prints the current version'
    def version
      puts "Current version is "+Hearken::VERSION
    end
  end
end