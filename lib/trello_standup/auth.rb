require "trello_standup"
require "trello_standup/helpers"
require "cgi"
require 'fileutils'

class TrelloStandup::Auth
  class << self
  include TrelloStandup::Helpers

    attr_accessor :credentials

    def username    # :nodoc:
      get_credentials[0]
    end

    def token    # :nodoc:
      get_credentials[1]
    end

    def get_credentials    # :nodoc:
      @credentials ||= (read_credentials || ask_for_and_save_credentials)
    end

    def ask_for_and_save_credentials
      print "*Enter your trello username:"
      username = ask
      sleep 1
      launchy("Openning Trello authorization page, please confirm access...", trello_oauth_url)
      print "*After authorization, please copy and paste your token for your trello account:"
      token = ask
      self.credentials = [username, token]
      write_credentials
      self.credentials
    end

    def open_trello_oauth_url
      %x(open #{trello_oauth_url})
    end

    def credentials_path
      "#{home_directory}/.trello_standup/credentials"
    end

    def write_credentials
      FileUtils.mkdir_p(File.dirname(credentials_path))
      File.open(credentials_path, 'w') {|credentials| credentials.puts(self.credentials)}
      FileUtils.chmod(0600, credentials_path)
    end

    def read_credentials
      if File.exists?(credentials_path)
        @credentials = File.read(credentials_path).split("\n")
      end
    end


    def delete_credentials
      if File.exists?(credentials_path)
        FileUtils.rm_f(credentials_path)
        @credentials = nil
      end
    end

    def login
      get_credentials
    end

    def logout
      delete_credentials
    end
  end
end
