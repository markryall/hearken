require 'hearken/command'

class Hearken::Command::Start
  include Hearken::Command
  help 'starts the player'
  execute {|ignored| @player.start }
end