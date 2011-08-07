require 'hearken/command'
require 'hearken/colour'

class Hearken::Command::Recent
  include Hearken::Command
  include Hearken::Colour

  usage '<count>'
  help 'lists the specified number of recently added albums'
  execute do |text|
    @player.library.reload unless @player.library.tracks
    all_tracks = @player.library.tracks.sort do |a, b|
      tc = a.timestamp <=> b.timestamp
      tc == 0 ? a.id <=> b.id : tc
    end
    maximum, current_album, tracks, total_count = text.to_i, nil, [], 0
    all_tracks.reverse.each do |track|
      unless current_album
        current_album = track.album
        tracks = [track]
        next
      end
      if current_album==track.album
        tracks << track
      else
        puts "#{c extract_artist(tracks), :yellow} #{c current_album, :cyan} #{tracks.size} tracks [#{tracks.last.search_id}-#{tracks.first.search_id}]"
        current_album = track.album
        tracks = [track]
        total_count += 1
      end
      break if total_count >= maximum
    end
  end
private
  def extract_artist tracks
    tracks.map{|t| t.artist}.uniq.size == 1 ? tracks.first.artist : 'various artists'
  end
end