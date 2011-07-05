require_relative '../../spec_helper'
require 'hearken/command/reload'

describe Hearken::Command::Reload do
  extend ShellShock::CommandSpec

  with_usage ''
  with_help 'reloads the contents of the music library for fast searching'

  before do
    @library = stub('library')
    @player = stub('player', :library => @library)
    @command = Hearken::Command::Reload.new @player
  end

  it 'should reload the library' do
    @library.should_receive(:reload)
    @command.execute '123'
  end
end