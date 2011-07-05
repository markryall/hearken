require_relative '../spec_helper'
require 'hearken/player'

describe Hearken::Player do
  let(:preferences) { {} }
  let(:player) { Hearken::Player.new preferences }

  before do
    scrobbler = mock 'scrobbler'
    library = mock 'library'
    Hearken::Scrobbler.stub!(:new).and_return scrobbler
    Hearken::Library.stub!(:new).and_return library
    library.stub! :reload
  end

  describe '#current' do
    it 'should return current_track when player has pid and file is present' do
      player.instance_eval { @pid = 1 }
      hash = stub 'hash'
      File.stub!(:exist?).with('current_song').and_return true
      YAML.stub!(:load_file).with('current_song').and_return hash
      player.current.should == hash
    end

    it 'should return nil when player has no pid and file is present' do
      player.instance_eval { @pid = nil }
      File.stub!(:exist?).with('current_song').and_return true
      player.current.should == nil
    end

    it 'should return nil when has pid and file is not present' do
      player.instance_eval { @pid = 1 }
      File.stub!(:exist?).with('current_song').and_return false
      player.current.should == nil
    end
  end
end
