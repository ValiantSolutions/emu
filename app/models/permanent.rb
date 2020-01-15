# frozen_string_literal: true

class Permanent < Alert

  validate :validate_actions
  #validate :validate_checkboxes

  validates :payload,
            :conditional,
            presence: {
              message: 'Requires a template body'
            }

  def validate_actions
    actions.each do |a|
      return if a.integratable&.valid?
    end
    errors.add(:actions, 'An alert requires at least one action to be selected.')
  end

  # before_update do |s|
  #   s&.actions&.each do |a|
  #     a.update!(enabled: false) if a.integratable.nil?
  #   end
  # end

  after_save do |s|
    unless s&.actions&.count == 3
      s&.actions&.destroy_all
      3.times { s.actions << Action.new }
    end
  end
end
