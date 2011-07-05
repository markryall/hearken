module Hearken
  module Debug
    def debug message
      if ENV['DEBUG']
        puts message 
      end
    end

    def pause
      if ENV['DEBUG']
        puts "Hit enter to continue"
        gets
      end
    end
  end
end