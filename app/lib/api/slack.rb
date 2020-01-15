# frozen_string_literal: true

module Api
  class Slack
    attr_accessor :token
    attr_accessor :client

    def initialize(slack)
      @channels = slack&.channels&.split(',')
      @token = slack&.secret
      @client = ::Slack::Web::Client.new(token: @token)
    end

    def is_valid?
      @client&.auth_test
      true
    rescue StandardError => e
      false
    end

    def send_message(msg)
      @channels&.each do |c|
        @client&.chat_postMessage(username: 'EMU Bot', channel: c, text: msg, as_user: false, icon_url: 'https://pbs.twimg.com/profile_images/647269569757753344/9fsP_HIy_400x400.jpg')
      end
    end
  end
end