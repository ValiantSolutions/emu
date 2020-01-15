# frozen_string_literal: true

class Guard < ApplicationRecord
  belongs_to :conditional

  validates :doc_hash,
            uniqueness: {
              scope: :conditional_id,
              case_sensitive: false
            }
end
