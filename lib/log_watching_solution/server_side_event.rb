module LogWatchingSolution
  class ServerSideEvent
    include ActionView::Helpers::TextHelper

    def initialize(io)
      @io = io
    end

    def write(file_path)
      file_data = tail(file_path)

      file_data.each do |line|
        # remove ascii color decorations from the string
        without_color_codes = line.gsub(/\e\[(\d+)m/, '')

        @io.write without_color_codes
      end
    end

    def close
      @io.close
    end

    private

    def tail(file_path)
      file = File.open(file_path).readlines
      total_lines = file.length

      @last_known_line_position ||= initial_line_position(total_lines)

      start_position = @last_known_line_position

      @last_known_line_position = total_lines

      file[start_position, total_lines]
    end

    def initial_line_position(total_lines)
      return 0 if total_lines.zero? || total_lines <= 10

      # print last 10 lines from the file
      total_lines - 10
    end
  end
end
