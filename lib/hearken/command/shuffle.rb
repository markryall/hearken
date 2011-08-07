require 'hearken/command'

class Hearken::Command::Shuffle
  include Hearken::Command
  help 'shuffles the current queue'
  execute do |ignored=nil|
    ids = []
    while track = @player.dequeue
      ids << track.id
    end
    ids.sort_by { rand }.each {|id| @player.enqueue id }
  end
end