require 'hearken/command'

class Hearken::Command::Search
  include Hearken::Command
  usage '*<word>'
  help <<EOF
searches for tracks containing the specified words (in artist, title or album)
ids are placed on the clipboard for convenient use with +
EOF
  execute do |text|
    terms = text.split(/\W/)
    matches = []
    @player.library.reload unless @player.library.tracks
    matches = []
    @player.library.tracks.each do |track|
      if terms.all? {|term| track.search_string.include? term }
        puts track
        matches << track.search_id
      end
    end
    puts "Found #{matches.size} matches (ids have been placed on clipboard)"
    matches.join(' ').to_clipboard
  end
end