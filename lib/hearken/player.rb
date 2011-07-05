require 'splat'

require 'hearken/queue'
require 'hearken/scrobbler'
require 'hearken/library'

module Hearken
  class Player
    include Queue
    attr_reader :library, :scrobbler
    attr_accessor :scrobbling, :matches

    def initialize preferences
      @scrobbler = Scrobbler.new preferences
      @scrobbling = true
      @library = Library.new preferences
      @library.reload
    end

    def c text,colour
      text.to_s.foreground colour
    end

    def status
      if @pid
        track = self.current
        puts "Since #{c Time.at(track.started), :cyan}\n\t#{track}"
        played = Time.now.to_i-track.started
        puts "#{c played, :yellow} seconds (#{c track.time.to_i-played, :yellow} remaining)" if track.time
      else
        puts 'not playing'.foreground(:yellow)
      end
    end

    def current
      (@pid and File.exist?('current_song')) ? YAML.load_file('current_song') : nil
    end

    def register track
      track.started = Time.now.to_i
      File.open('current_song', 'w') {|f| f.print track.to_yaml }
    end

    def start
      if @pid
        puts "Already started (pid #{@pid})"
        return
      end
      @pid = fork do
        player_pid = nil
        Signal.trap('TERM') do
          Process.kill 'TERM', player_pid if player_pid
          exit
        end
        total_tracks = @library.count
        loop do
          id = dequeue || (rand * total_tracks).to_i
          row = @library.row id
          unless row
            puts "track with id #{id} did not exist"
            next
          end
          path = @library.path row
          unless path and File.exist? path
            puts "track with id #{id} did not refer to a file"
            next
          end
          @library.with_track(id) do |track|
            @scrobbler.update track if @scrobbling
            register track
            player_pid = path.to_player
            Process.wait player_pid
            @scrobbler.scrobble track if @scrobbling
          end
        end
      end
      puts "Started (pid #{@pid})"
    end

    def stop
      return unless @pid
      Process.kill 'TERM', @pid 
      @pid = nil
    end

    def restart
      stop
      start
    end
  end
end