# frozen_string_literal: true

module Templating
  class Slack < Liquid::Block
    def initialize(tag_name, args, tokens)
      super
    end

    def render(context)
      if context.registers.key?('Integration::Slack')
        @slack = context.registers['Integration::Slack']
        if context.registers.key?('job')
          @job = context.registers['job']
          @log = log_action(super.strip)
        end
        begin
          @slack&.send_message(super.strip) unless super.strip.empty?
        rescue StandardError => e
          details = ''
          details = @log&.details unless @log&.details.nil?
          details = "#{details} #{e}".strip
          @log&.update!(details: details)
        end
      end
      super
    end

    def log_action(data)
      @slack.logs.create!(job: @job, body: data.truncate(65_535)) unless @job.nil? || data.empty?
    end
  end
end

Liquid::Template.register_tag('slack', Templating::Slack)