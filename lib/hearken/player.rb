require 'splat'
require 'fileutils'

require 'hearken/queue'
require 'hearken/scrobbler'
require 'hearken/notification/growl_notifier'
require 'hearken/library'

module Hearken
  class Player
    include Queue
    attr_reader :library, :scrobbler

    def initialize preferences
      @scrobbler = Scrobbler.new preferences
      @scrobbler.enabled = true
      @growl = Hearken::Notification::GrowlNotifier.new preferences
      @notifiers = [@scrobbler, @growl]
      @library = Library.new preferences
      @library.reload
      create_paths
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

    def notify_started track
      @notifiers.each {|notifier| notifier.started track if notifier.respond_to? :started}
    end

    def notify_finished track
      @notifiers.each {|notifier| notifier.finished track if notifier.respond_to? :finished}
    end

    def scrobbling tf
      @scrobbler.enabled = tf
    end

    def start
      return if @pid
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
            notify_started track
            register track
            player_pid = path.to_player
            Process.wait player_pid
            notify_finished track
          end
        end
      end
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