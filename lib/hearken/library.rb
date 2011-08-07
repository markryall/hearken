require 'hearken/track'
require 'hearken/paths'

class Hearken::Library
  include Hearken::Paths

  FILE_FIELDS = %w{path timestamp}
  TAG_FIELDS = %w{album track title artist time date albumartist puid mbartistid mbalbumid mbalbumartistid asin}
  FIELDS = FILE_FIELDS + TAG_FIELDS

  include Hearken::Debug
  attr_reader :tracks

  def initialize preferences
    create_paths
  end

  def count
    @tracks.count
  end

  def row id
    @tracks[id]
  end

  def with_track id
    yield @tracks[id]
  end

  def reload
    @tracks = []
    File.open index_path do |file|
      id = 0
      while line = file.gets
        row = line.chomp.split '<->'
        track = Hearken::Track.new id
        FIELDS.each {|field| track.send "#{field}=", row.shift }
        @tracks << track
        id += 1
      end
      @tracks.sort! do |a, b|
        tc = a.timestamp <=> b.timestamp
        tc == 0 ? a.id <=> b.id : tc
      end
    end if File.exist? index_path
  end
end