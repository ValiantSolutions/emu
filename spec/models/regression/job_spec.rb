# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job, type: :model do
  describe 'factory' do
    it 'is valid' do
      expect(FactoryBot.create(:job)).to be_valid
    end
  end

  describe 'relationships' do
    before(:each) do
      @job = FactoryBot.create(:job)
    end

    it 'belongs_to schedule' do
      assc = @job.class.reflect_on_association(:schedule)
      expect(assc.macro).to eq :belongs_to
    end

    it 'belongs_to alert' do
      assc = @job.class.reflect_on_association(:alert)
      expect(assc.macro).to eq :belongs_to
    end

    # it 'has_many slices' do
    #   assc = @job.class.reflect_on_association(:slices)
    #   expect(assc.macro).to eq :has_many
    # end

    # it 'sums all the slice events' do
    #   @response = file_fixture('elastic_search_results.json').read
    #   @slice_a = FactoryBot.create(:slice, scroll_id: 0, raw_response: @response)
    #   @slice_b = FactoryBot.create(:slice, scroll_id: 1, raw_response: @response)
    #   @job.slices << @slice_a
    #   @job.slices << @slice_b
    #   expect(@job.raw_event_count).to eq(20_000)
    # end
  end
end