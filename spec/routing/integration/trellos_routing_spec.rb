# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Integration::TrellosController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/integrations/trello').to route_to('integration/trellos#index')
    end

    it 'routes to #new' do
      expect(get: '/integrations/trello/new').to route_to('integration/trellos#new')
    end

    it 'routes to #show' do
      expect(get: '/integrations/trello/1').to route_to('integration/trellos#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/integrations/trello/1/edit').to route_to('integration/trellos#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/integrations/trello').to route_to('integration/trellos#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/integrations/trello/1').to route_to('integration/trellos#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/integrations/trello/1').to route_to('integration/trellos#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/integrations/trello/1').to route_to('integration/trellos#destroy', id: '1')
    end
  end
end
