# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Conditional, type: :model do
  before(:each) do
    @alert = FactoryBot.build(
      :alert,
      conditional: FactoryBot.build(:conditional),
      payload: FactoryBot.build(:payload),
      search: Search.first || FactoryBot.create(:search)
    )
    @alert.actions << FactoryBot.create(:action)
    @alert.save!
    @conditional = @alert.conditional
    # @conditional = FactoryBot.create(:conditional)
  end

  describe 'validates Conditional' do
    it 'has a valid factory' do
      expect(@conditional).to be_valid
    end
  end

  describe 'uses single table inheritance' do
    it 'from Template' do
      expect(@conditional).to be_a(Template)
    end
  end

  describe 'conditional relationships' do
    it 'belongs to an instance of alert' do
      expect(@conditional.alert).to be_a(Alert)
      expect(@conditional.alert).to be_a(Permanent)
      expect(@conditional.alert.permanent?).to be_truthy
    end
  end

  describe 'conditional templating' do
    before(:each) do
      @alert = FactoryBot.build(
          :alert_temporary,
          name: 'My New Alert 123',
          conditional: FactoryBot.build(:conditional),
          payload: FactoryBot.build(:payload),
          search: Search.first || FactoryBot.create(:search)
        )
      @alert.actions << FactoryBot.create(:action)
      @alert.save!
      @job = FactoryBot.create(:job, alert: @alert)
      raw_response = JSON.parse(file_fixture('elastic_search_results.json').read)

      @response = raw_response&.dig('hits', 'hits')
      @actionable_events = @job.alert.conditional.actionable_events(@job, @response, false)
    end

    it 'returns an array of actionable events' do
      expect(@conditional.body).to eq('{{ true }}')
      expect(@actionable_events).to be_a(Array)
    end

    it 'properly applies the template and returns 5 results' do
      @conditional = FactoryBot.create(
        :conditional,
        body: "{% if event.day_of_week == 'Sunday' %}{{ true }}{% endif %}"
      )
      expect(@conditional.actionable_events(@job, @actionable_events, false).size).to eq(5)
    end

    it 'properly applies the template and returns 0 results' do
      @conditional = FactoryBot.create(
        :conditional,
        body: "{% if event.day_of_week == 'DebugDay' %}{{ true }}{% endif %}"
      )
      expect(@conditional.actionable_events(@job, @actionable_events, false).size).to eq(0)
    end
  end
end