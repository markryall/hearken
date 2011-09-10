require 'hearken/command'

class Hearken::Command::Remove
  include Hearken::Command
  usage '*<word>'
  help 'removes all tracks that match the specified criteria - specifying no criteria will flush entire queue'
  execute do |text|
    @terms = text.split(/\W/)
    ids = []
    while track = @player.dequeue
      ids << track.id unless @terms.all? {|term| track.search_string.include? term }
    end
    ids.each {|id| @player.enqueue id }
  end
end