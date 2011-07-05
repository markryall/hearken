require 'hearken/tagged'

class String
  def escape char
    gsub(char, "\\#{char}")
  end

  def escape2 char
    split(char).join("\\#{char}")
  end
end

module Hearken::Indexing::Executor
  include Hearken::Tagged

  def extract_file_attributes path
    @path = path.to_s
    @timestamp = path.timestamp
  end

  def clean_path path
    path.escape(" ").escape2("'").escape("!").escape2("`").escape("(").escape(")").escape2("&").escape2(";")
  end

  def execute command
    debug command
    `#{command} 2>&1`
  end

  def debug message
    puts message if ENV['DEBUG']
  end
end