require 'hearken/paths'
require 'hearken/indexing/persistant_traverser'

class Hearken::Indexing::Indexer
  include Hearken::Paths

  def initialize path
    create_paths
    @path = path
  end

  def execute
    start = Time.now
    count = 0
    traverser = Hearken::Indexing::PersistantTraverser.new @path, index_path

    traverser.each do |audio_file|
      count += 1
      show_progress start, count if count % 1000 == 0
    end

    show_progress start, count

    system "play #{File.dirname(__FILE__)}/../../../media/applause.mp3"
  end
private
  def show_progress start, count
    elapsed = Time.now-start
    $stderr.puts "Processed #{count} audio files in #{elapsed} seconds (#{elapsed/count} per file)"
  end
end