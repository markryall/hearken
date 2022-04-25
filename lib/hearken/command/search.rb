# frozen_string_literal: true

module Hearken
  module Command
    class Search
      attr_reader :help

      def initialize(library)
        @help = <<~EOF
          searches for tracks containing the specified words (in artist, title or album)
          ids are placed on the clipboard for convenient use with +
        EOF
        @library = library
      end

      def execute(text)
        terms = text.split(/\W/)
        matches = []
        @library.tracks.each do |track|
          if terms.all? { |term| track.search_string.include? term }
            puts track
            matches << track.search_id
          end
        end

        if matches.size < 50
          IO.popen("pbcopy", "w") { |clipboard| clipboard.print matches.join " " }
          puts "Found #{matches.size} matches (ids have been placed on clipboard)"
        else
          puts "Found #{matches.size} matches"
        end
      end
    end
  end
end
