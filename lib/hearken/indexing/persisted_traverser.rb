require 'hearken/track'

class Hearken::Indexing::PersistedTraverser
  include Enumerable

  def initialize path
    @path = path
  end

  def each
    File.open @path  do |file|
      while line = file.gets
        row = line.chomp.split '<->'
        track = Hearken::Track.new
        Hearken::Tagged::FIELDS.each {|field| track.send "#{field}=", row.shift }
        yield track
      end
    end if File.exist? @path
  end

  def clear
    File.open @path, 'w'
  end

  def append track
    File.open(@path, 'a') do |file|
      file.puts track.to_a.join('<->')
    end
  end
end