# frozen_string_literal: true

require "fileutils"

module Hearken
  module Paths
    attr_reader :base_path, :index_path

    def create_paths
      @base_path = ".hearken".from_home
      @index_path = ".hearken/music".from_home
    end

    def in_base_dir(&block)
      Dir.chdir(base_path, &block)
    end
  end
end
