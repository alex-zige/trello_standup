require "trello_standup/command/base"

# Display Trello updates in standup format.  (generate)
class TrelloStandup::Command::Generate < TrelloStandup::Command::Base

  # generate
  #
  # generate feeds from trello updates.
  def index
    TrelloStandup::Command::Help.new.send(:help_for_command, current_command)
  end

  # generate:updates
  #
  # Pull trello udpates and for organisation
  #
  #Example:
  #
  # $ trello_standup generate:updates
  # Populating updates...
  # Fetching updates from trello
  # Launch text editor with formatted trello updates

  def updates
    display "Populating updates..."
    TrelloStandup::Trello.generate_updates
    display "Completed."
  end

  alias_command "generate", "generate:updates"
end
