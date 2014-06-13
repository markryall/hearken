require 'hearken/tagged'
require 'hearken/colour'

class Hearken::Track
  include Hearken::Tagged
  include Hearken::Colour

  attr_accessor :id, :started

  def initialize id=nil
    @id = id
  end

  def [] key
    self.send key
  end

  def valid?
    @track
  end

  def search_id
    id.to_s 36
  end

  def search_string
    "#{self.artist.to_s.downcase}#{self.album.to_s.downcase}#{self.title.to_s.downcase}"
  end

  def to_s
    "[#{my(:search_id,:white)}] #{my(:artist, :yellow)} #{my(:album,:cyan)} #{my(:track,:magenta)} #{my(:title,:green)} (#{my(:time,:white)})"
  end

  def to_short_s
    "#{track} #{title}\n#{artist}\n#{album}"
  end

  def my field, colour
    c self.send(field).to_s, colour
  end
end