require 'hearken/command'

class Hearken::Command::Status
  include Hearken::Command
  help 'shows the current player status'
  execute {|ignored| puts @player.status }
end