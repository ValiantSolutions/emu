# frozen_string_literal: true

class Search < ApplicationRecord
  attr_encrypted :query,
                 key: Rails.application.credentials.attr_encrypted,
                 encode: true,
                 encode_iv: true,
                 encode_salt: true

  attr_encrypted :indices,
                 key: Rails.application.credentials.attr_encrypted,
                 marshal: true,
                 allow_empty_value: true,
                 encode: true,
                 encode_iv: true,
                 encode_salt: true

  has_many :alerts, dependent: :destroy

  belongs_to :user
  belongs_to :elastic_endpoint


  before_validation do |s|
    s.indices = s.indices.gsub(/ /, '') unless s.indices.blank?
  end

  validates_associated :elastic_endpoint

  validates :name,
            uniqueness: {
              message: 'A search already exists with that name. Please choose another.',
              case_sensitive: false
            },
            presence: {
              message: 'Please specify a name for this search.'
            },
            format: {
              with: /\A[A-Za-z0-9 ]+\z/,
              message: 'Search names may only contain alphanumeric and space characters.'
            }

  validates :indices,
            presence: {
              message: 'A search requires at least one index.'
            }

  validates :query,
            presence: {
              message: 'Enter a query'
            }

  def index_array
    indexes = []
    indices.split(',').each do |i|
      indexes.push(i)
    end
    indexes
  end
end
