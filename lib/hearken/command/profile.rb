require 'hearken/command'

class Hearken::Command::Profile
  include Hearken::Command
  help 'launches last fm profile'
  execute {|ignored| @player.profile }
end