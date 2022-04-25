# frozen_string_literal: true

require "hearken/paths"
require "hearken/indexing/persistant_traverser"

module Hearken
  module Indexing
    class Indexer
      include Hearken::Paths

      def initialize(path)
        create_paths
        @path = path
      end

      def execute
        start = Time.now
        count = 0
        traverser = Hearken::Indexing::PersistantTraverser.new @path, index_path

        traverser.each do |_audio_file|
          count += 1
          show_progress start, count if (count % 1000).zero?
        end

        show_progress start, count

        system "afplay #{File.dirname(__FILE__)}/../../../media/applause.mp3"
      end

      private

      def show_progress(start, count)
        elapsed = Time.now - start
        warn "Processed #{count} audio files in #{elapsed} seconds (#{elapsed / count} per file)"
      end
    end
  end
end
