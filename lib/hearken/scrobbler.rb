require 'splat'
require 'hearken/simple_scrobbler'
require 'hearken/debug'

# Modified version of simple_scrobbler gem from https://github.com/threedaymonk/simple_scrobbler
module Hearken
  class Scrobbler
    API_KEY = '21f8c75ad38637220b20a03ad61219a4'
    SECRET = 'ab77019c84eef8bc16bcfd5ba8db0c5d'
    include Debug

    def initialize preferences
      @preferences = preferences
    end

    def enabled= tf
      @scrobbler = nil
      if @preferences['lastfm'] and tf
        debug "Configuring scrobbler with #{@preferences['lastfm'].inspect}"
        user, session = *%w{user session_key}.map{|k| @preferences['lastfm'][k]}
        @scrobbler = SimpleScrobbler.new API_KEY, SECRET, user, session
      end
    end

    def finished track
      return unless @scrobbler
      debug "Scrobbling to last fm: #{track}"
      send_to_scrobbler :scrobble, track
    end

    def started track
      return unless @scrobbler
      debug "Updating now listening with last fm: #{track}"
      send_to_scrobbler :now_playing, track
    end

    def love track
      return unless @scrobbler and track
      debug "Sending love to last fm: #{track}"
      send_to_scrobbler :love, track
    end

    def profile
      return unless @scrobbler
      @scrobbler.with_profile_url {|url| url.to_launcher }
    end

    def ask question
      print question
      $stdin.gets.chomp
    end

    def setup
      preferences = {}
      preferences['user'] = ask 'What is your lastfm user name ? '
      @scrobbler = SimpleScrobbler.new API_KEY, SECRET, preferences['user']
      preferences['session_key'] = @scrobbler.fetch_session_key do |url|
        url.to_launcher
        ask 'Please hit enter when you\'ve allowed this application access to your account'
      end
      @preferences['lastfm'] = preferences
    end
private
    def send_to_scrobbler message, track
      begin
        debug %w{artist title time album track}.map {|k| "#{k}=#{track.send(k)}"}.join(',')
        @scrobbler.send message, track.artist,
          track.title,
          :duration => track.time,
          :album => track.album,
          :trackNumber => track.track.to_i,
          :timestamp => Time.now.to_i
      rescue Exception => e
        puts "Failed to scrobble: #{e}"
      end
    end
  end
end