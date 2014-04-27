require "trello_standup"
require "trello_standup/helpers"
require "cgi"

class TrelloStandup::Trello
  class << self

  include TrelloStandup::Helpers

    def generate_updates
      stdout ||= ""
      user_actions = Trello::Member.find(TrelloStandup::Auth.username).actions
      grouped_actions = user_actions.select do |n|
        n.type == 'updateCard' && !n.data['listAfter'].nil? && is_in_valid_date_range(n.date)
      end.group_by{ |a| a.data['board']['name']}
        display "Fetching updates from trello"
        stdout += "From #{1.day.ago.beginning_of_day.to_formatted_s(:long)} To #{Time.now.beginning_of_day.to_formatted_s(:long)}\n"
      if !grouped_actions.empty?
        display "Launch text editor with formatted trello updates..."
        display "Waiting for proofreading...."
        grouped_actions.keys.each do |key|
          stdout += "Project: *#{key}*\n"
          grouped_actions[key].uniq!{|a| a.data['card']['name']}.each do |action|
                if card_is_completed(action.data['listAfter']['name'])
                  # stdout += "Completed - #{action.data['card']['name']} on \n"
                  stdout +="Completed - "
                  stdout += trello_link(card_link_path(action.data['card']['shortLink']),"#{action.data['card']['name']}")
                  stdout +="\n"
                end
          end
        end
        open_stdoutput_in_text_editor(stdout)
        push_hipchat(stdout)
      else
        display "No card has been completed."
      end
    end

    def card_is_completed(list_after_name)
      #TODO: obtain from config
      list_after_name == "Done" || list_after_name == "Ready for review" || list_after_name == "Review - TestFlight / Staging"
    end

    def is_in_valid_date_range(date)
      (5.day.ago.beginning_of_day <= date) && ( date <= Time.now.beginning_of_day)
    end

    def card_link_path(short_link)
      "https://trello.com/c/#{short_link}"
    end

    def trello_link(link_path,card_name)
      "<a href=\"#{link_path}\">#{card_name}</a>"
    end

    def push_hipchat(message)
      message.gsub!("\n","<br/>")
      hipchat_token = "xxxxxxx"
      hipchat_room = "xxxxxxx"
      format = 'html' #html/ or text
      uri = URI.parse('http://api.hipchat.com/v1/rooms/message')
      response = Net::HTTP.post_form(uri, {
        'auth_token' => hipchat_token,
        'room_id' => hipchat_room,
        'message' => message,
        'from' => 'Deploy Bot',
        'message_format' => format
      })
    end

  end
end
