module Hearken
  module Queue
    def enqueue id
      @sequence ||= 0
      @library.with_track id do |track|
        File.open("#{Time.now.to_i}-#{@sequence.to_s.rjust(8,'0')}.song", 'w') {|f| f.print track.to_yaml }
        @sequence += 1
      end
    end

    def each
      Dir.glob('*.song').sort.each do |file|
        yield YAML.load File.read(file)
      end
    end

    def dequeue
      file = Dir.glob('*.song').sort.first
      return nil unless file
      hash = YAML.load(File.read(file))
      id = hash[:id] if hash
      FileUtils.rm file
      id
    end
  end
end