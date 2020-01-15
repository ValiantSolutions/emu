# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Guard, type: :model do
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
    @guard = FactoryBot.create(:guard, conditional: @conditional)
  end

  describe 'factory' do
    it 'is valid' do
      expect(@guard).to be_valid
    end
  end

  it { should validate_uniqueness_of(:doc_hash).scoped_to(:conditional_id).case_insensitive }
end