# frozen_string_literal: true

require "hearken/tagged"
require "hearken/colour"

module Hearken
  class Track
    include Hearken::Tagged
    include Hearken::Colour

    attr_accessor :id, :started

    def initialize(id = nil)
      @id = id
    end

    def [](key)
      send key
    end

    def valid?
      @track
    end

    def search_id
      id.to_s 36
    end

    def search_string
      "#{artist.to_s.downcase}#{album.to_s.downcase}#{title.to_s.downcase}#{date}"
    end

    def to_s
      [
        "[#{my(:search_id, :white)}]",
        my(:artist, :yellow),
        my(:album, :cyan),
        my(:track, :magenta),
        my(:title, :green),
        my(:date, :white),
        my(:time, :white)
      ].join(" ")
    end

    def to_short_s
      "#{track} #{title}\n#{artist}\n#{album}"
    end

    def my(field, colour)
      c send(field).to_s, colour
    end
  end
end
