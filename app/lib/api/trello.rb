# frozen_string_literal: true

require 'trello'

module Api
  class Trello

    def initialize(trello)
      client = ::Trello::Client.new(
        developer_public_key: trello.token,
        member_token: trello.secret
      )
      @user = ::Trello::Member.parse(client.get('/members/me/'))
      @user.client = client
    end

    def boards
      @boards ||= threadsafe_boards
    end

    def board(board_id)
      return nil if boards.empty?
      t = Thread.new do
        Rails.application.executor.wrap do
          Thread.current[:board] = @user&.boards&.find(board_id)&.first
        end
      end
      t.join
      t[:board]
    end

    def board_name(board_id)
      return 'Unknown/Missing' if boards.empty?
      board(board_id)&.name
    end

    def create_card(options)
      t = Thread.new do
        Rails.application.executor.wrap do
          Thread.current[:card] = @user&.client&.create(:card, options)
        end
      end
      t.join
      t[:card]
    end

    def get_list_by_id(list_id)
      @user&.client&.find(:list, list_id)
    end

    def search(client, query, opts = {})
      # gem issue or pebcak? you decide.
      action = ::Trello::Action.new
      response = client.get("/search/", { query: query }.merge(opts))
      action.parse_json(response).except("options").each_with_object({}) do |(key, data), result|
        klass = "::Trello::#{key.singularize.capitalize}".constantize
        result[key] = klass.from_json(data)
      end
    end

    def find(query, options)
      t = Thread.new do
        Rails.application.executor.wrap do
          Thread.current[:results] = search(@user&.client, query, options)
        end
      end
      t.join
      t[:results]
    end

    def create_list(options)
      t = Thread.new do
        Rails.application.executor.wrap do
          Thread.current[:list] = @user&.client&.create(:list, options)
        end
      end
      t.join
      t[:list]
    end

    def create_label(options)
      t = Thread.new do
        Rails.application.executor.wrap do
          Thread.current[:label] = @user&.client&.create(:label, options)
        end
      end
      t.join
      t[:label]
    end

    private

    def threadsafe_boards
      t = Thread.new do
        Rails.application.executor.wrap do
          Thread.current[:boards] = @user.boards.map { |b| [b.name, b.id] }
        end
      end
      t.join
      t[:boards]
    end
  end
end