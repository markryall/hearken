# frozen_string_literal: true

require "hearken/debug"
require "hearken/paths"
require "hearken/track"

module Hearken
  class Library
    include Hearken::Paths

    FILE_FIELDS = %w[path timestamp].freeze
    TAG_FIELDS = %w[album track title artist time date albumartist puid mbartistid mbalbumid mbalbumartistid asin].freeze
    FIELDS = FILE_FIELDS + TAG_FIELDS

    include Hearken::Debug
    attr_reader :tracks

    def initialize
      @tracks = []
      create_paths
      reload
    end

    def count
      @tracks.count
    end

    def row(id)
      @tracks[id]
    end

    def with_track(id)
      yield @tracks[id]
    end

    def reload
      return unless File.exist?(index_path)

      File.open index_path do |file|
        id = 0
        while (line = file.gets)
          row = line.chomp.split "<->"
          track = Hearken::Track.new id
          FIELDS.each { |field| track.send "#{field}=", row.shift }
          @tracks << track
          id += 1
        end
      end
    end
  end
end
