require 'hearken/indexing/ffmpeg_file'

module Hearken::Indexing::Parser
  def self.parse path
    Hearken::Indexing::FfmpegFile.new path
  end
end