# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Integration::EmailsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/administration/integrations/email').to route_to('integration/emails#index')
    end

    it 'routes to #new' do
      expect(get: '/administration/integrations/email/new').to route_to('integration/emails#new')
    end

    it 'routes to #show' do
      expect(get: '/administration/integrations/email/1').to route_to('integration/emails#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/administration/integrations/email/1/edit').to route_to('integration/emails#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/administration/integrations/email').to route_to('integration/emails#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/administration/integrations/email/1').to route_to('integration/emails#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/administration/integrations/email/1').to route_to('integration/emails#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/administration/integrations/email/1').to route_to('integration/emails#destroy', id: '1')
    end
  end
end
