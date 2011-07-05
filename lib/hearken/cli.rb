require 'thor'

require 'hearken/version'
require 'hearken/indexing'

module Hearken
  class Cli < Thor
    desc 'version', 'Prints the current version'
    def version
      puts "Current version is "+Hearken::VERSION
    end

    desc 'index DIRECTORY', 'Reindexes a music collection'
    def index directory
      Hearken::Indexing::Indexer.new(directory).execute
    end

    desc 'console', 'Enters console for queuing and playing tracks'
    def console
    end
  end
end