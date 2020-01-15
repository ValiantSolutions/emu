# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Action, type: :model do
  before(:each) do
    @action = FactoryBot.create(:action)
  end

  describe 'validates Action' do
    it 'has a valid factory' do
      expect(@action).to be_valid
    end

    it 'is polymorphic' do
      expect(@action.integratable).to be_a(Integration::Trello)
    end

    it 'belongs_to an integration' do
      assc = @action.class.reflect_on_association(:integratable)
      expect(assc.macro).to eq :belongs_to
    end

    it 'can access the integration attributes' do
      expect(@action.integratable.name).to eq('Our Awesome Test Trello')
    end

    it 'disables the action if integratable is nil' do
      @action.update!(integratable: nil)
      expect(@action.enabled).to be_falsy
    end

    it 'can access the global id' do
      expect(@action.integratable_gid).to be_a(GlobalID)
    end

    it 'can find the model by the global id' do
      @gid = @action.integratable_gid
      @action.integratable_gid = @gid
      expect(@action.integratable).to be_a(Integration::Trello)
    end

    it 'disables the action after integration destroy' do 
      @action.integratable.destroy!
      @action.reload
      expect(@action.integratable).to eq(nil)
      expect(@action.enabled).to be_falsy
    end
  end
end