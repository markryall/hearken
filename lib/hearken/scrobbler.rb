require 'splat'
require 'simple_scrobbler'
require 'hearken/debug'

module Hearken
  class Scrobbler
    include Debug

    def initialize preferences
      @preferences = preferences
    end

    def enabled= tf
      @scrobbler = nil
      if @preferences['lastfm'] and tf
        debug "Configuring scrobbler with #{@preferences['lastfm'].inspect}"
        @scrobbler = SimpleScrobbler.new *%w{api_key secret user session_key}.map{|k| @preferences['lastfm'][k]}
      end
    end

    def finished track
      return unless @scrobbler
      debug "Scrobbling to last fm: #{track}"
      send_to_scrobbler :submit, track
    end

    def started track
      return unless @scrobbler
      debug "Updating now listening with last fm: #{track}"
      send_to_scrobbler :now_playing, track
    end

    def ask question
      print question
      $stdin.gets.chomp
    end

    def setup
      puts <<-EOF
      Because of the way lastfm authentication works, setting up lastfm involves two steps:
      Firstly, you need to register that you are developing an application. This will give you an api key and an associated 'secret'
      Secondly, you need to gives your application access your lastfm account.  This will give a authenticated session.

      Step 1. Logging in to your lastfm account and register an application
      This will launch a browser.  You need to log in and fill out the API registration form
      EOF
      answer = ask 'Are you ready ? '
      return unless answer.downcase.start_with? 'y'
      "http://www.last.fm/api/account".to_launcher
      preferences = {}
      preferences['api_key'] = ask 'What is your API key ? '
      preferences['secret'] = ask 'What is your secret ? '
      puts <<-EOF
      Now you've got you application details, you need to create an authentication session between your application and your lastfm account
      Step 2. Authorising your application to access your lastfm account
      This will launch another browser. You just need to give your application permission to access your account
      EOF
      preferences['user'] = ask 'What is your lastfm user name ? '
      @scrobbler = SimpleScrobbler.new preferences['api_key'], preferences['secret'], preferences['user']
      preferences['session_key'] = @scrobbler.fetch_session_key do |url|
        url.to_launcher
        ask 'Hit enter when you\'ve allowed your application access to your account'
      end
      @preferences['lastfm'] = preferences
    end
private
    def send_to_scrobbler message, track
      begin
        debug %w{artist title time album track}.map {|k| "#{k}=#{track.send(k)}"}.join(',')
        @scrobbler.send message, track.artist,
          track.title,
          :length => track.time,
          :album => track.album,
          :track_number => track.track
      rescue Exception => e
        puts "Failed to scrobble: #{e}"
      end
    end
  end
end