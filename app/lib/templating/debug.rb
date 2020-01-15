# frozen_string_literal: true

module Templating
  class Debug < Liquid::Block
    def initialize(tag_name, tokens)
      super
    end

    def render(context)
      begin
        if context.registers.key?('job')
          @job = context.registers['job']
          log_action(super.strip)
        end
      rescue StandardError => e
        #puts e
      end
      super
    end

    def log_action(data)
      unless @job.nil?
        @job.alert.payload.log = Log.new(job: @job, body: data.truncate(65_535))
        @job.alert.payload.save!
      end
    end
  end
end

Liquid::Template.register_tag('debug', Templating::Debug)