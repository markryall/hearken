require_relative '../spec_helper'
require 'hearken/player'

describe Hearken::Player do
  let(:preferences) { {} }
  let(:player) { Hearken::Player.new preferences }

  before do
    scrobbler = double 'scrobbler'
    library = double 'library'
    allow(Hearken::Scrobbler).to receive(:new) { scrobbler }
    allow(Hearken::Library).to receive(:new) { library }
    allow(library).to receive(:reload)
    allow(scrobbler).to receive(:enabled=)
  end

  describe '#current' do
    it 'should return current_track when player has pid and file is present' do
      player.instance_eval { @pid = 1 }
      hash = double 'hash'
      allow(File).to receive(:exist?).with('current_song') { true }
      allow(YAML).to receive(:load_file).with('current_song') { hash }
      expect(player.current).to eq(hash)
    end

    it 'should return nil when player has no pid and file is present' do
      player.instance_eval { @pid = nil }
      allow(File).to receive(:exist?).with('current_song') { true }
      expect(player.current).to be_nil
    end

    it 'should return nil when has pid and file is not present' do
      player.instance_eval { @pid = 1 }
      allow(File).to receive(:exist?).with('current_song') { false }
      expect(player.current).to be_nil
    end
  end
end
