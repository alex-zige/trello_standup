require "trello_standup"
require "trello"

Trello.configure do |config|
  config.developer_public_key = "bb958efe971bcf0f5d0fa920c9b377b3"
  config.member_token = "e882ad3bebe860467334992d768b67b47a859e0354a224ab4431a6ac3430e2b5"
end

class TrelloStandup::CLI
  def self.start
    grouped_actions = Trello::Member.find("alexzige").actions.select { |n| n.type == 'updateCard' && !n.data['listAfter'].nil?}.group_by{ |a| a.data['board']['name']}
    p "Yesterday"
    grouped_actions.keys.each do |key|
      p "Project: *#{key}*"
      grouped_actions[key].each do |action|
          if action.data['listAfter']['name'] == "Done" or  action.data['listAfter']['name'] == "Ready for review"
            p "- #{action.data['card']['name']}"
          end
      end
    end
  end
end
