module TrelloStandup
  module Helpers
    extend self

    def home_directory
      ENV['HOME']
    end

    def trello_oauth_url
      'https://trello.com/1/authorize?key=bb958efe971bcf0f5d0fa920c9b377b3&name=Trello+Standup&expiration=never&response_type=token'
    end

    def format_date(date)
      date = Time.parse(date).utc if date.is_a?(String)
      date.strftime("%Y-%m-%d %H:%M %Z").gsub('GMT', 'UTC')
    end

    def ask
      $stdin.gets.to_s.strip
    end

    def open_stdoutput_in_text_editor(stdout)
      %x[echo "#{stdout}" | subl -w]
    end

    def error(message)
      display("failed")
      $stderr.puts(format_with_bang(message))
      exit(1)
    end

    def format_with_bang(message)
      return '' if message.to_s.strip == ""
      " !    " + message.split("\n").join("\n !    ")
    end

    def longest(items)
      items.map { |i| i.to_s.length }.sort.last
    end

    def confirm(message="Are you sure you wish to continue? (y/n)")
      display("#{message} ", false)
      ['y', 'yes'].include?(ask.downcase)
    end

    def launchy(message, url)
        require("launchy")
        launchy = Launchy.open(url)
    end

    def display(msg="", new_line=true)
      if new_line
        puts(msg)
      else
        print(msg)
      end
      $stdout.flush
    end

    def styled_array(array, options={})
      fmt = line_formatter(array)
      array = array.sort unless options[:sort] == false
      array.each do |element|
        display((fmt % element).rstrip)
      end
      display
    end

    def styled_error(error, message='Trello Standup client internal error.')
      display("failed")
      $stderr.puts(format_error(error, message))
    end

    def format_error(error, message='Trello client internal error.')
      formatted_error = []
      formatted_error << " !    #{message}"
      formatted_error << ' !    Or report a bug at: https://github.com/alex-zige/trello-standup/issues/new'
      formatted_error << ''
      formatted_error << "    Error:       #{error.message} (#{error.class})"
      formatted_error << "    Backtrace:   #{error.backtrace.first}"
      error.backtrace[1..-1].each do |line|
        formatted_error << "                 #{line}"
      end
      if error.backtrace.length > 1
        formatted_error << ''
      end
      command = ARGV.map do |arg|
        if arg.include?(' ')
          arg = %{"#{arg}"}
        else
          arg
        end
      end.join(' ')
      formatted_error << "    Command:     trello_standup #{command}"
      formatted_error.join("\n")
      end
    end


end
