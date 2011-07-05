require 'hearken/command'

class Hearken::Command::Reload
  include Hearken::Command
  help 'reloads the contents of the music library for fast searching'
  execute {|ignored| @player.library.reload }
end