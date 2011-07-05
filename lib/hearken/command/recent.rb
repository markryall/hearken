require 'hearken/command'

class Hearken::Command::Recent
  include Hearken::Command
  usage '<count>'
  help 'lists the specified number of recently added albums'
  execute do |text|
    @player.library.reload unless @player.library.tracks
    maximum, current_album, tracks, total_count = text.to_i, nil, [], 0
    @player.library.tracks.reverse.each do |track|
      unless current_album
        current_album = track.album
        tracks = [track]
        next
      end
      if current_album==track.album
        tracks << track
      else
        puts "#{current_album} - #{extract_artist tracks} - #{tracks.size} tracks (#{tracks.last.search_id}-#{tracks.first.search_id})"
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