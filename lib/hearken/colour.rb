require 'rainbow'

module Hearken::Colour
  def c text,colour
    Rainbow(text.to_s).color colour
  end
end