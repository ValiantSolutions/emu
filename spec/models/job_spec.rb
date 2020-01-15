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
  end
end