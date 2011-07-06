require 'hearken/paths'

module Hearken::Queue
  include Hearken::Paths

  def enqueue id
    in_queue_dir do 
      @sequence ||= 0
      @library.with_track id do |track|
        File.open("#{Time.now.to_i}-#{@sequence.to_s.rjust(8,'0')}.song", 'w') {|f| f.print track.to_yaml }
        @sequence += 1
      end
    end
  end

  def each
    in_queue_dir do
      Dir.glob('*.song').sort.each do |file|
        yield YAML.load_file file
      end
    end
  end

  def dequeue
    in_queue_dir do
      file = Dir.glob('*.song').sort.first
      return nil unless file
      hash = YAML.load_file file
      id = hash[:id] if hash
      FileUtils.rm file
      id
    end
  end
end