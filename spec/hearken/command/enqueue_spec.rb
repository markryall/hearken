require_relative '../../spec_helper'
require 'hearken/command/enqueue'

describe Hearken::Command::Enqueue do
  extend ShellShock::CommandSpec

  with_usage '*<id>'
  with_help 'enqueues the list of songs with the specified ids'

  before do
    @player = double 'player'
    @command = Hearken::Command::Enqueue.new @player
  end

  it 'should enqueue whatever is returned from the expander' do
    expander = double 'expander'
    allow(Hearken::RangeExpander).to receive(:new) { expander }
    allow(expander).to receive(:expand).with('some text') { [1,2,3] }

    [1,2,3].each {|id| expect(@player).to receive(:enqueue).with(id) }

    @command.execute "some text"
  end
end