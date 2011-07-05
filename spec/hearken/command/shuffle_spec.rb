require_relative '../../spec_helper'
require 'hearken/command/shuffle'

describe Hearken::Command::Shuffle do
  extend ShellShock::CommandSpec

  with_usage ''
  with_help 'shuffles the current queue'

  before do
    @player = stub 'player'
    @command = Hearken::Command::Shuffle.new @player
  end

  it 'should dequeue all tracks, shuffle then enqueue them' do
    @player.should_receive(:dequeue).and_return(1)
    @player.should_receive(:dequeue).and_return(2)
    @player.should_receive(:dequeue).and_return(3)
    @player.should_receive(:dequeue).and_return nil

    @player.should_receive(:enqueue).with 3
    @player.should_receive(:enqueue).with 2
    @player.should_receive(:enqueue).with 1

    @command.execute
  end
end