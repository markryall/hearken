require_relative '../../spec_helper'
require 'hearken/command/shuffle'

describe Hearken::Command::Shuffle do
  extend ShellShock::CommandSpec

  with_usage ''
  with_help 'shuffles the current queue'

  before do
    @player = double 'player'
    @command = Hearken::Command::Shuffle.new @player
  end

  it 'should dequeue all tracks, shuffle then enqueue them' do
    track = double 'track'

    expect(track).to receive(:id) { 1 }
    expect(track).to receive(:id) { 2 }
    expect(track).to receive(:id) { 3 }

    expect(@player).to receive(:dequeue) { track }
    expect(@player).to receive(:dequeue) { track }
    expect(@player).to receive(:dequeue) { track }
    expect(@player).to receive(:dequeue) { nil }

    expect(@player).to receive(:enqueue) { 1 }
    expect(@player).to receive(:enqueue) { 2 }
    expect(@player).to receive(:enqueue) { 3 }

    @command.execute
  end
end