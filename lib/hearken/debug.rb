# frozen_string_literal: true

module Hearken
  module Debug
    def debug(message)
      puts message if ENV["DEBUG"]
    end

    def pause
      if ENV["DEBUG"]
        puts "Hit enter to continue"
        gets
      end
    end
  end
end
