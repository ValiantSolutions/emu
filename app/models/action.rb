# frozen_string_literal: true

class Action < ApplicationRecord
  default_scope { order(id: :asc) }
  
  belongs_to :alert
  belongs_to :integratable, polymorphic: true, optional: true

  before_save do |a|
    a.enabled = false if a.integratable.nil?
  end

  def integratable_gid
    integratable&.to_global_id
  end
  
  # Set the :bloggable from a Global ID (handles the form submission)
  def integratable_gid=(gid)
    self.integratable = GlobalID::Locator.locate gid
  end
  
end