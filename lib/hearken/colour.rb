module Hearken::Colour
  def c text,colour
    text.to_s.foreground colour
  end
end