# frozen_string_literal: true

module Integration
  class Base < ApplicationRecord
    self.abstract_class = true
    has_many :actions, as: :integratable
    has_many :alerts, through: :actions

    before_destroy do |s|
      s&.actions&.each do |a|
        a.update!(integratable: nil, enabled: false)
      end
    end

    #delegate :alert, to: :action
  end
end
