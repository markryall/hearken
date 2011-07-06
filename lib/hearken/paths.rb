require 'fileutils'

module Hearken::Paths
  attr_reader :preferences_path, :queue_path, :index_path

  def create_paths
    @preferences_path = '.hearken/config'.from_home
    @queue_path = '.hearken/queue'.from_home
    @index_path = '.hearken/music'.from_home
    FileUtils.mv '.hearken'.from_home, '.hearken.tmp'.from_home if File.exist?('.hearken'.from_home) && File.file?('.hearken'.from_home)
    FileUtils.mkdir_p '.hearken/queue'.from_home
    FileUtils.mv '.hearken.tmp'.from_home, @preferences_path if File.exist? '.hearken.tmp'.from_home
    FileUtils.mv '.music'.from_home, @index_path if File.exist? '.music'.from_home
  end

  def in_queue_dir
    Dir.chdir(queue_path) { yield }
  end
end