require 'hearken/indexing/file'
require 'hearken/indexing/executor'
require 'hearken/monkey_violence'
require 'pathname'

class Hearken::Indexing::FfmpegFile
  include Hearken::Indexing::Executor

  def self.from_file path
    file = Hearken::Indexing::File.new Pathname.new path
    Hearken::Indexing::FfmpegFile.new file
  end

  def initialize path
    extract_file_attributes path
    content = execute "ffprobe #{@path.escape_for_sh}"
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
              add_meta m.pre_match.strip.downcase.to_sym, m.post_match.strip if m
            rescue ArgumentError => e
            end
          end
      end
    end

    @title = tag :title, :tit2
    @album = tag :album, :talb
    @artist = tag :artist, :tpe1, :tpe2
    @albumartist = tag :album_artist, :tso2
    @time = to_duration tag :duration
    @date = tag :date, :tdrc, :tyer
    @track = tag :track, :trck
    @puid = tag :"musicip puid"
    @mbartistid = tag :musicbrainz_artistid, :"musicbrainz artist id"
    @mbalbumid = tag :musicbrainz_albumid,:"musicbrainz album id"
    @mbalbumartistid = tag :musicbrainz_albumartistid, :"musicbrainz album artist id"
    @asin = tag :asin
  end

  def add_meta key, value
    @meta[key] ||= value
  end

  def tag *names
    names.each { |name| return @meta[name] if @meta[name] }
    nil
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
