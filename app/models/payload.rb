# frozen_string_literal: true

class Payload < Template
  validates :body,
            presence: {
              message: 'Payload required.'
            }

  def template_vars(job, results)
    @template_vars = super(results)
    @template_vars['actionable_events'] = job&.alert&.conditional&.actionable_events(job, results)&.map do |a|
      expand_dot_notation(a['_source'].merge('_emu_id' => a['_id'], '_emu_index' => a['_index'], '_emu_score' => a['_score']))
    end
    @template_vars['actionable_event_count'] = @template_vars['actionable_events'].size
    @template_vars
  end

  def expand_dot_notation(to_convert)
    new_hash = {}
    to_convert.each do |key, val|
      new_key, new_sub_key = key.to_s.split('.')
      new_key = new_key
      unless new_sub_key.nil?
        new_sub_key = new_sub_key
        new_hash[new_key] = {} if new_hash[new_key].nil?
        new_hash[new_key].merge!({new_sub_key => val})
      else
        new_hash.store(key, val)
      end
    end
    new_hash
  end

  def apply_template(job, results)
    @template = parse
    return nil if @template.nil?
    rendered_template = alert_template(job, results)

    if alert&.temporary?
      self.log = Log.new(job: job, body: rendered_template)
      save!
    end

    return rendered_template.html_safe if log&.loggable&.html?
    rendered_template
  end

  private

  def alert_template(job, results)
    alert_template_vars = template_vars(job, results)
    job.update!(actionable_event_count: alert_template_vars['actionable_event_count'])
    @template&.render(alert_template_vars, registers: payload_registers(job))
  rescue StandardError => e
    nil
  end

  def payload_registers(job)
    registers = {}
    job&.alert&.actions&.each do |a|
      registers[a&.integratable_type] = a&.integratable if a&.enabled?
    end
    registers['job'] = job
    registers
  end

end
