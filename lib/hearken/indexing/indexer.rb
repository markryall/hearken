module Hearken
  module Indexing
    PATH = File.expand_path('~')+'/.music'
  end
end

require 'splat'

class Hearken::Indexing::Indexer
  def initialize path
    @path = path
  end

  def execute
    start = Time.now
    count = 0
    #traverser = AudioLibrary::PersistantTraverser.new ARGV.shift, ARGV.shift

    #traverser.each do |audio_file|
    #  count += 1
    #  show_progress start, count if count % 1000 == 0
    #end

    #show_progress start, count

    (File.dirname(__FILE__)+'/../../../media/applause.mp3').to_player
  end
private
  def show_progress start, count
    elapsed = Time.now-start
    $stderr.puts "Processed #{count} audio files in #{elapsed} seconds (#{elapsed/count} per file)"
  end
end