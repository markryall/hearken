require 'hearken/command'

class Hearken::Command::Flush
  include Hearken::Command
  help 'flushes the current queue'
  execute {|ignored| loop { break unless @player.dequeue } }
end