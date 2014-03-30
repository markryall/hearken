require 'yaml'
require 'hearken/paths'
require 'hearken/monkey_violence'

module Hearken; end

module Hearken
  class Preferences
    include Hearken::Paths

    def initialize
      create_paths
      if File.exists? preferences_path
        @preferences = YAML.load_file preferences_path
      else
        @preferences = {}
      end
    end

    def [] key
      @preferences[key]
    end

    def []= key, value
      @preferences[key] = value
      persist
    end

    def persist
      File.open(preferences_path, 'w') {|f| f.puts @preferences.to_yaml}
    end
  end
end