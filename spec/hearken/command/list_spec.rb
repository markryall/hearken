require_relative '../../spec_helper'
require 'hearken/command/list'

describe Hearken::Command::List do
  extend ShellShock::CommandSpec

  with_help <<EOF
lists the contents of the track queue
these results can optionally be filtered by specified words
when playing, approximate times for each track will be displayed
EOF

  before do
    @player = double 'player'
    @command = Hearken::Command::List.new @player
  end

  it 'should display nothing when there is no current track and nothing enqueued' do
    allow(@player).to receive(:current) { nil }
    allow(@player).to receive(:each)
    @command.execute ''
  end

  it 'should display queue contents with no times when there is no current track' do
    track = double 'track'
    allow(@player).to receive(:current) { nil }
    allow(@player).to receive(:each).and_yield track
    expect(@command).to receive(:puts).with(track)
    @command.execute ''
  end
end
