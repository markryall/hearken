require 'hearken/command'

class Hearken::Command::SetupScrobbling
  include Hearken::Command
  help 'runs through the steps required to get lastfm scrobbling working'
  execute {|ignored| @player.scrobbler.setup }
end