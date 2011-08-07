require 'hearken/command'
require 'hearken/colour'

class Hearken::Command::List
  include Hearken::Command
  include Hearken::Colour

  usage '*<word>'
  help <<EOF
lists the contents of the track queue
these results can optionally be filtered by specified words
when playing, approximate times for each track will be displayed
EOF
  execute do |text|
    @terms = text.split(/\W/)
    current = @player.current
    if current
      next_start_time = Time.at current.started
      show next_start_time, current
    end
    next_start_time += current.time.to_i if next_start_time && current.time
    @player.each do |track|
      show next_start_time, track
      next_start_time += track.time.to_i if next_start_time && track.time
    end
  end

  def show time, track
    return unless @terms.empty? or @terms.all? {|term| track.search_string.include? term }
    puts time ? "#{c time.strftime("%H:%M:%S %d/%m/%Y"), :blue} #{track}" : track
  end
end