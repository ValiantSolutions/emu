# frozen_string_literal: true

module Templating
  class Trello < Liquid::Block
    def initialize(tag_name, input, tokens)
      super
      trello_options = input.split(',').map { |o| YAML.safe_load(o.strip) if o =~ Liquid::TagAttributes }.reduce(:merge)

      @list_name = trello_options['list']
      @title = trello_options['title']
      @label = trello_options['label'] if trello_options.key?('label')

      @tokens = tokens
    end

    def render(context)
      if context.registers.key?('Integration::Trello')
        @trello = context.registers['Integration::Trello']
        if context.registers.key?('job')
          @job = context.registers['job']
          @log = log_action(super.strip)
        end
        begin
          unless @title.blank? || @list_name.blank?
            @trello&.create_card(
              parse_attributes(@list_name, context), parse_attributes(
                @title,
                context
              ), super.strip,
              parse_attributes(
                @label, context
              ))
          end
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
      @trello.logs.create!(job: @job, subject: @title, body: data.truncate(65_535)) unless @job.nil? || data.empty?
    end

    def parse_attributes(var, context)
      if var.is_a?(String) && var.match(Liquid::PartialTemplateParser)
        tmp_var = var.dup
        vars = capture_variables(var)
        vars.each do |v|
          liquid_var = Liquid::Variable.new(v.first, @tokens).render(context).to_s
          tmp_var.gsub!(/\{\{\s*?(#{Regexp.quote(v.first)})\s*?\}\}/, liquid_var)
        end
        return tmp_var
      end
      return var
    rescue StandardError => e
      var
    end

    def capture_variables(var)
      var.scan(/\{\{\s*?(\S+)\s*?\}\}/)
    end
  end
end

Liquid::Template.register_tag('trello', Templating::Trello)