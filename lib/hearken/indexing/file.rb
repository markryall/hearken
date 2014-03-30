module Hearken; module Indexing; end; end

class Hearken::Indexing::File
  def initialize path, root=nil
    @path, @root = path, root
  end

  def timestamp
    @path.mtime.to_i.to_s
  end

  def to_s
    @path.to_s
  end
end