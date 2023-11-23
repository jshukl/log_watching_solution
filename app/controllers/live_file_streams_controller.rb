require 'log_watching_solution/sse'
require 'log_watching_solution/log_file'

class LiveFileStreamsController < ApplicationController
  include ActionController::Live

  def log
    response.headers['Content-Type'] = 'text/event-stream'
    response.headers['Last-Modified'] = Time.now.httpdate

    sse = LogWatchingSolution::Sse.new(response.stream)
    log_file_path = Rails.root.join('log/development.log').to_s
    file = LogWatchingSolution::LogFile.new

    # watch development.log file for changes
    Filewatcher.new([log_file_path]).watch do |_file_path, event_type|
      next unless event_type.to_s.eql?('updated')

      file_lines = file.added_lines(log_file_path)
      sse.write(file_lines)
    end
  ensure
    sse.close
  end
end
