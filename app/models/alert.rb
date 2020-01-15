# frozen_string_literal: true

class Alert < ApplicationRecord
  belongs_to :user
  belongs_to :search

  has_one :payload, dependent: :destroy
  has_one :conditional, dependent: :destroy

  has_many :schedules, dependent: :destroy
  has_many :actions, dependent: :destroy, autosave: true
  has_many :jobs, dependent: :destroy
  has_many :guards, through: :conditional, dependent: :destroy

  ### working kinda has_one :slack, source: :integratable, through: :actions, source_type: "Integration::Slack"

  has_many :actions, dependent: :destroy
  has_one :action, dependent: :destroy
  has_one :slack, through: :action, source: :integratable, source_type: 'Integration::Slack'
  has_one :trello, through: :action, source: :integratable, source_type: 'Integration::Trello'
  has_one :email, through: :action, source: :integratable, source_type: 'Integration::Email'

  accepts_nested_attributes_for :search
  accepts_nested_attributes_for :payload
  accepts_nested_attributes_for :conditional
  accepts_nested_attributes_for :actions

  enum deduplication: %i[deduplicate_on_event_id deduplicate_on_event_content deduplicate_disabled]

  # def integratable
  #   self.action.try(:integratable)
  # end

  # def integratable=(newEntity)
  #   self.build_action(integratable: newEntity)
  # end

  validates :name,
            uniqueness: {
              message: 'An alert already exists with that name. Please choose another.',
              case_sensitive: false
            },
            presence: {
              message: 'Please specify a name for this alert.'
            },
            format: {
              with: /\A[A-Za-z0-9 ]+\z/,
              message: 'Alert names may only contain alphanumeric and space characters.'
            }

  validates :deduplication_fields,
            presence: {
              message: 'Specify the event fields.'
            },
            if: :deduplication_fields?

  before_validation do |a|
    a.deduplication_fields = a.deduplication_fields.gsub(/ /, '') unless a.deduplication_fields.blank?
  end

  def temporary?
    is_a?(Temporary)
  end

  def permanent?
    is_a?(Permanent)
  end

  def deduplication_fields?
    deduplicate_on_event_content?
  end
end