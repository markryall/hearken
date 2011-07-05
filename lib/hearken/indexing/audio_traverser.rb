require 'pathname'
require 'hearken/indexing/file'

class Hearken::Indexing::AudioTraverser
  attr_reader :current
  EXTS = %w{m4a mp3 ogg wma}.map {|e| '.'+e }

  def initialize path
    @path = Pathname.new path
  end

  def each
    @path.find { |child| yield Hearken::Indexing::File.new child, @path if is_audio? child }
  end
private
  def is_audio? current
    current.file? and EXTS.include? current.extname.downcase
  end
end