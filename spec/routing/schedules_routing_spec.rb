# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SchedulesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/alerting/schedules').to route_to('schedules#index')
    end

    it 'routes to #new' do
      expect(get: '/alerting/schedules/new').to route_to('schedules#new')
    end

    it 'routes to #trigger' do
      expect(put: '/alerting/schedules/1/trigger').to route_to('schedules#trigger', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/alerting/schedules/1/edit').to route_to('schedules#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/alerting/schedules').to route_to('schedules#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/alerting/schedules/1').to route_to('schedules#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/alerting/schedules/1').to route_to('schedules#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/alerting/schedules/1').to route_to('schedules#destroy', id: '1')
    end
  end
end
