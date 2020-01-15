# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Integration::SlacksController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/integrations/slack').to route_to('integration/slacks#index')
    end

    it 'routes to #new' do
      expect(get: '/integrations/slack/new').to route_to('integration/slacks#new')
    end

    it 'routes to #show' do
      expect(get: '/integrations/slack/1').to route_to('integration/slacks#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/integrations/slack/1/edit').to route_to('integration/slacks#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/integrations/slack').to route_to('integration/slacks#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/integrations/slack/1').to route_to('integration/slacks#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/integrations/slack/1').to route_to('integration/slacks#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/integrations/slack/1').to route_to('integration/slacks#destroy', id: '1')
    end
  end
end
