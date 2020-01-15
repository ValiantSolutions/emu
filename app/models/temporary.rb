# frozen_string_literal: true

class Temporary < Alert

  has_one :job
  
  before_validation do |t|
    t.name = "Debug Alert #{rand(36**6).to_s(36)}" if t.name.blank?
  end

  def on_success(status, options)
    alert = Temporary.find_by_id(options['id'])
    result = Result.find_by_id(options['result_id'])
    alert&.search&.update!(status: :completed) if alert&.search&.searching?
    result&.update!(status: :completed)
  end
end