require 'json'

module LogWatchingSolution
  class Sse
    def initialize(io)
      @io = io
    end

    def write(file_lines)
     file_lines.each do |line|
      @io.write line
     end
    end

    def close
      @io.close
    end
  end
end
