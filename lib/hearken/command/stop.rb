require 'hearken/command'

class Hearken::Command::Stop
  include Hearken::Command
  help 'stops the player'
  execute {|ignored| @player.stop }
end