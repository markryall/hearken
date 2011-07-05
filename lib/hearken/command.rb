module Hearken
  module Command
    attr_reader :usage, :help

    def self.included cls
      cls.extend ClassMethods
    end

    def self.load name, *args
      require "hearken/command/#{name}"
      classname = name.to_s.split('_').map{|s|s.capitalize}.join
      Hearken::Command.const_get(classname).new *args
    end

    def initialize player
      @player = player
      @usage = ''
      @help = ''
    end

    module ClassMethods
      def usage usage
        define_method(:usage) { usage }
      end

      def help help
        define_method(:help) { help }
      end

      def execute &block
        define_method :execute, block
      end
    end
  end
end