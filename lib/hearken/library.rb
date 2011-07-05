require 'hearken/track'

class Hearken::Library
  FILE_FIELDS = %w{path timestamp}
  TAG_FIELDS = %w{album track title artist time date albumartist puid mbartistid mbalbumid mbalbumartistid asin}
  FIELDS = FILE_FIELDS + TAG_FIELDS

  include Hearken::Debug
  attr_reader :tracks

  def initialize preferences
  end

  def count
    @tracks.count
  end

  def row id
    @tracks[id]
  end

  def path row
    row.path
  end

  def with_track id
    yield @tracks[id]
  end

  def reload
    s = Time.now.to_i
    path = File.expand_path('~')+'/.music'
    @tracks = []
    File.open path do |file|
      id = 0
      while line = file.gets
        row = line.chomp.split '<->'
        track = Hearken::Track.new id
        FIELDS.each {|field| track.send "#{field}=", row.shift }
        @tracks << track
        id += 1
      end
    end if File.exist? path
    puts "Reloaded db with #{@tracks.size} tracks in #{Time.now.to_i-s} seconds"
  end
end