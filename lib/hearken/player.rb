require 'fileutils'

require 'hearken/queue'
require 'hearken/scrobbler'
require 'hearken/notification/growl_notifier'
require 'hearken/library'
require 'hearken/colour'

module Hearken
  class Player
    include Queue
    include Colour
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

    def status
      if @pid
        track = self.current
        played = Time.now.to_i-track.started
        timing = "(#{c track.time.to_i-played, :yellow} remaining)" if track.time
        puts "#{c Time.at(track.started).strftime("%H:%M:%S %d/%m/%Y"), :blue}: #{track} #{timing}"
      else
        puts 'not playing'.foreground(:yellow)
      end
    end

    def love
      @scrobbler.love current
    end

    def profile
      @scrobbler.profile
    end

    def current
      in_base_dir do
        (@pid and File.exist?('current_song')) ? YAML.load_file('current_song') : nil
      end
    end

    def register track
      track.started = Time.now.to_i
      in_base_dir do
        File.open('current_song', 'w') {|f| f.print track.to_yaml }
      end
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

    def random_track
      @library.row (rand * @library.count).to_i
    end

    def start
      return if @pid
      if @library.count == 0
        puts 'Player can not be started with an empty library'
        puts 'Please run "hearken_index" in another shell and then \'reload\''
        return
      end
      @pid = fork do
        player_pid = nil
        Signal.trap('TERM') do
          Process.kill 'TERM', player_pid if player_pid
          exit
        end
        loop do
          track = dequeue || random_track
          next unless track
          unless File.exist? track.path
            puts "skipping track as #{track.path} does not exist"
            next
          end
          notify_started track
          register track
          player_pid = spawn "play \"#{track.path.escape("\`")}\""
          Process.wait player_pid
          notify_finished track
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