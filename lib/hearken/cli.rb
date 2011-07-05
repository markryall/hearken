require 'thor'

require 'hearken'
require 'hearken/indexing'
require 'hearken/console'

class Hearken::Cli < Thor
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
    Hearken::Console.new.push
  end
end