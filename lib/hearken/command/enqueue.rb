require 'hearken/range_expander'
require 'hearken/command'

class Hearken::Command::Enqueue
  include Hearken::Command
  usage '*<id>'
  help 'enqueues the list of songs with the specified ids'
  execute do |text|
    @expander ||= Hearken::RangeExpander.new
    @expander.expand(text).each {|id| @player.enqueue id }
  end
end
