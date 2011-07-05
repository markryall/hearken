require 'hearken/command'

class Hearken::Command::Restart
  include Hearken::Command
  help 'stops and restarts the player (which will kill the current track)'
  execute {|ignored| @player.restart }
end