require 'hearken/monkey_violence'

module Hearken::Notification
end

class Hearken::Notification::GrowlNotifier
  def initialize preferences
    @growlnotify = !`which growlnotify`.chomp.empty?
    @image_path = File.expand_path File.dirname(__FILE__)+'/../../../media/ice_cream.png'
  end

  def started track
    `growlnotify -t "Hearken unto ..." --image #{@image_path} -m \"#{track.to_short_s.escape_for_sh_quoted}\"` if @growlnotify
  end
end