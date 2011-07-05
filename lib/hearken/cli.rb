require 'thor'

require 'hearken/version'

module Hearken
  class Cli < Thor
    desc 'version', 'Prints the current version'
    def version
      puts "Current version is "+Hearken::VERSION
    end

    desc 'index', 'Reindexes a music collection'
    def index
    end

    desc 'console', 'Enters console for queuing and playing tracks'
    def console
    end
  end
end