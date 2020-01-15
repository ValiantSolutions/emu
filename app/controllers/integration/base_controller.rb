# frozen_string_literal: true

module Integration
  class BaseController < ApplicationController
    breadcrumb 'Integrations', '', match: :exact
  end
end