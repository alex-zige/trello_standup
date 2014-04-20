require "trello_standup"
require "trello"
require "trello_standup/helpers"
require "cgi"
require "trello_standup/command"
require "trello_standup/auth"

Trello.configure do |config|
  config.developer_public_key = "bb958efe971bcf0f5d0fa920c9b377b3"
  config.member_token = "e882ad3bebe860467334992d768b67b47a859e0354a224ab4431a6ac3430e2b5"
end

class TrelloStandup::CLI
  class << self
    include TrelloStandup::Helpers
  end

  def self.start(*args)
   begin
    if $stdin.isatty
      $stdin.sync = true
    end
    if $stdout.isatty
      $stdout.sync = true
    end
    command = args.shift.strip rescue "help"
    TrelloStandup::Command.load
    TrelloStandup::Command.run(command, args)
  rescue Interrupt
    `stty icanon echo`
    error("Command cancelled.")
  rescue => error
    styled_error(error)
    exit(1)
  end

end

  #helpers
  def self.card_is_completed(list_after_name)
    list_after_name == "Done" ||list_after_name == "Ready for review"
  end

  def self.is_in_valid_date_range(date)
    (1.day.ago.beginning_of_day <= date) && ( date <= Time.now.beginning_of_day)
    # true
  end

  #open link
  def open_oauth_link
    "https://trello.com/1/authorize?key=bb958efe971bcf0f5d0fa920c9b377b3&name=Trello+Standup&expiration=never&response_type=token"
  end
end
