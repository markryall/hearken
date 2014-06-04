require_relative '../../spec_helper'
require 'hearken/command/reload'

describe Hearken::Command::Reload do
  extend ShellShock::CommandSpec

  with_usage ''
  with_help 'reloads the contents of the music library for fast searching'

  before do
    @library = double 'library'
    @player = double 'player'
    allow(@player).to receive(:library) { @library }
    @command = Hearken::Command::Reload.new @player
  end

  it 'should reload the library' do
    expect(@library).to receive(:reload)
    @command.execute '123'
  end
end