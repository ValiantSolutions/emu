# frozen_string_literal: true

class Conditional < Template
  has_many :guards

  validates :body,
            presence: {
              message: 'Conditional required.'
            }

  def actionable_events(job, results, log_template = true)
    apply_template(job, results, log_template)
  end

  private

  def apply_template(job, results, log_template)
    conditioned_events = []
    conditional_vars = template_vars(results)
    template = parse
    if alert&.temporary? && log_template
      self.log = Log.new(job: job, body: conditional_vars['raw_events'].to_json.truncate(65_500))
      save!
    end
    return conditioned_events if template.nil?
    conditional_vars['raw_events']&.each do |r|
      conditional_vars['event'] = r.dig('_source')
      conditional_vars['event_index'] = r.dig('_index')
      conditional_vars['event_score'] = r.dig('_score')
      conditional_render = template.render(conditional_vars.to_liquid).gsub(/[\r|\n]+/, '').strip
      conditioned_events.push(r) if conditional_render.eql? 'true'
    end
    process_guards(conditioned_events)
  end

  def process_guards(conditioned_events)
    return conditioned_events if alert&.temporary? || alert&.deduplicate_disabled?

    if alert&.deduplicate_on_event_content? && !alert&.deduplication_fields.blank?
      process_events_as_guarded_hash(conditioned_events)
    elsif alert&.deduplicate_on_event_id?
      process_events_as_guarded_doc_id(conditioned_events)
    else
      conditioned_events
    end
  end

  def process_events_as_guarded_doc_id(conditioned_events)
    unguarded_events = []
    Guard.transaction do
      conditioned_events.each do |c|
        doc_id = c.dig('_id')
        next if doc_id.nil?
        unguarded_events.push(c) if process_guard(doc_id)
      end
    end
    unguarded_events
  end

  def process_events_as_guarded_hash(conditioned_events)
    unguarded_events = []
    Guard.transaction do
      conditioned_events.each do |c|
        doc_fields = c.dig('_source')
        next if doc_fields.nil?
        doc_hash = generate_document_string(doc_fields, alert&.deduplication_fields&.split(','))
        unguarded_events.push(c) if process_guard(doc_hash)
      end
    end
    unguarded_events
  end

  def process_guard(doc_identifier)
    new_guard_added = false
    guard = Guard.find_or_create_by(
      conditional: self,
      doc_hash: Digest::SHA1.hexdigest(doc_identifier)
    ).increment!(:hits)
    new_guard_added = true if guard&.hits&.eql?(1)
    new_guard_added
  end

  def generate_document_string(doc_fields, hash_fields)
    doc_values_combined = String.new
    hash_fields.sort.each do |h|
      field_value = if h.include?('.')
                      doc_fields.dig(*h.split('.').map(&:to_s))
                    else
                      doc_fields.dig(h)
                    end
      doc_values_combined += field_value.to_s unless field_value.nil?
    end
    doc_values_combined
  end
end
