# frozen_string_literal: true

require "hearken/command/enqueue"
require "hearken/command/reload"
require "hearken/command/search"
require "hearken/library"
require "shell_shock/context"

module Hearken
  class Console
    include ShellShock::Context

    def initialize
      @prompt = "hearken > "
      library = Hearken::Library.new
      add_command(Hearken::Command::Enqueue.new(library), "enqueue")
      add_command(Hearken::Command::Reload.new(library), "reload")
      add_command(Hearken::Command::Search.new(library), "search")
    end
  end
end
