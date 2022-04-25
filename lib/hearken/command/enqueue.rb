# frozen_string_literal: true

require "yaml"
require "hearken/range_expander"

module Hearken
  module Command
    class Enqueue
      attr_reader :usage, :help

      def initialize(library)
        @usage = "*<id>"
        @help = "enqueues the list of songs with the specified ids"
        @expander = Hearken::RangeExpander.new
        @library = library
      end

      def execute(text)
        `mkdir -p /tmp/queue`
        @expander.expand(text).each do |id|
          @library.with_track id do |track|
            meta = {
              title: track.title,
              artist: track.artist,
              album: track.album,
              length: track.time.to_i,
              path: track.path
            }
            File.open("/tmp/queue/#{(Time.now.to_f * 1000).to_i}.yml", "w") { |f| f.puts meta.to_yaml }
          end
        end
      end
    end
  end
end
