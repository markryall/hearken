require 'shell_shock/context'

require 'hearken'
require 'hearken/player'
require 'hearken/preferences'
require 'hearken/command'

require 'yaml'

module Hearken
  class Console
    include ShellShock::Context

    def with name, *aliases
      aliases << name.to_s if aliases.empty?
      add_command Command.load(name, @player), *aliases
    end

    def with_all *names
      names.each {|name| with name}
    end

    def initialize
      preferences = Preferences.new
      @player = Player.new preferences
      at_exit { @player.stop }
      @prompt = "hearken > "
      with :status, "'"
      with :restart, 'next', 'k'
      with :list, 'ls'
      with :enqueue, 'add', '+'
      with :remove, 'rm', '-'
      with :start, 'play', 'go'
      with :search, 'find'
      with_all *%w{reload stop scrobbling shuffle setup_scrobbling recent love profile}
    end
  end
end