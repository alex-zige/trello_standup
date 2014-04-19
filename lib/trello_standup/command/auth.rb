require "trello_standup/command/base"

# authentication  (login, logout, whoami)
class TrelloStandup::Command::Auth < TrelloStandup::Command::Base

  # auth
  #
  # Authenticate, display token and current user
  def index
    TrelloStandup::Command::Help.new.send(:help_for_command, current_command)
  end

  # auth:login
  #
  # log in with your Trello credentials
  #
  #Example:
  #
  # $ trello_standup auth:login
  # Enter your Trell username:
  # Username: your-trello-user-name
  # Launch authenication page in browse
  # After authorization, please copy and paste your token for your trello account:
  # Copy and Past the trello access token
  # Authentication successful!
  # You currently logged in with Trello username : 'your-trello-user-name'

  def login
      TrelloStandup::Auth.login
      display "Authentication successful!"
      display "You currently logged in with Trello username : '#{TrelloStandup::Auth.username}'"
  end
  alias_command "login", "auth:login"

  # auth:logout
  #
  # clear your Trello credentials
  #
  #Example:
  #
  # $ trello_standup auth:logout
  # "Local credentials cleared."

  def logout
      TrelloStandup::Auth.logout
      display "Local credentials cleared."
  end
  alias_command "logout", "auth:logout"

  # auth:whoami
  #
  # display your heroku email address
  #
  #Example:
  #
  # $ trello_standup auth:whoami
  # username
  #
  def whoami
    display TrelloStandup::Auth.username
  end
  alias_command "whoami", "auth:whoami"

end