require 'hearken/tagged'
require 'hearken/monkey_violence'

module Hearken::Indexing::Executor
  include Hearken::Tagged

  def extract_file_attributes path
    @path = path.to_s
    @timestamp = path.timestamp
  end

  def execute command
    debug command
    `#{command} 2>&1`
  end

  def debug message
    puts message if ENV['DEBUG']
  end
end