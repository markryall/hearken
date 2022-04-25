# frozen_string_literal: true

module Hearken
  module Command
    class Reload
      def initialize(library)
        @library = library
      end

      def help
        "reload the contents of the music library for fast searching"
      end

      def execute(_text)
        @library.reload
      end
    end
  end
end
