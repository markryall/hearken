require 'hearken/indexing/executor'

class Hearken::Indexing::FfmpegFile
  include Hearken::Indexing::Executor

  def initialize path
    extract_file_attributes path
    content = execute "ffmpeg -i #{clean_path @path}"
    state = :draining
    @meta = {}
    content.each_line do |line|
      l = line.chomp
      case l
        when "  Metadata:"
          state = :metadata
        else
          if state == :metadata
            begin
              m = / *: */.match l
              @meta[m.pre_match.strip] = m.post_match.strip if m
            rescue ArgumentError => e
            end
          end
      end
    end

    @title = @meta['TIT2'] || @meta['title']
    @album = @meta['TALB'] || @meta ['album']
    @artist = @meta['TPE1'] || @meta['TPE2'] || @meta['artist']
    @albumartist = @meta['TSO2'] || @meta['album_artist']
    @time = to_duration @meta['Duration']
    @date = @meta['TDRC'] || @meta['TYER'] || @meta['date']
    @track = @meta['TRCK'] || @meta['track']
    @puid = @meta['MusicIP PUID']
    @mbartistid = @meta['MusicBrainz Artist Id']
    @mbalbumid = @meta['MusicBrainz Album Id']
    @mbalbumartistid = @meta['MusicBrainz Album Artist Id']
    @asin = @meta['ASIN']
  end

  def method_missing method
    @meta[method.to_s]
  end
private
  def to_duration s
    return nil unless s
    first, *rest = s.split ','
    hours, minutes, seconds = first.split ':'
    seconds.to_i + (minutes.to_i * 60) + (hours.to_i * 60 * 60)
  end
end