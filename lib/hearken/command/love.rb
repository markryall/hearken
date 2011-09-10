require 'hearken/command'

class Hearken::Command::Love
  include Hearken::Command
  help 'sends love for the current track to last fm'
  execute {|ignored| @player.love }
end