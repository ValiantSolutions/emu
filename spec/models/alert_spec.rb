# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Alert, type: :model do
  before(:each) do
    @alert = FactoryBot.create(:alert_temporary)
  end

  describe 'validates Alert' do
    it 'has a valid factory' do
      expect(@alert).to be_valid
    end
  end

  describe 'the relationships' do
    it 'has many actions' do
      assc = @alert.class.reflect_on_association(:actions)
      expect(assc.macro).to eq :has_many
    end

    it 'can save an action' do
      @action = FactoryBot.build(:action)
      expect do
        @alert.actions << @action
      end.to change(Action, :count).by(1)
      expect(@alert.actions.last).to be_valid
    end

    it 'is not valid with no actions' do
      @perm_alert = FactoryBot.build(:alert)
      expect(@perm_alert.valid?).to be_falsy
    end

    it 'can access the integration' do
      @action = FactoryBot.build(:action)
      @alert.actions << @action
      expect(@alert.actions.last.integratable).to be_a(Integration::Trello)
      expect(@alert.actions.last.integratable.name).to eq('Our Awesome Test Trello')
    end

    it 'can access the slack integration directly' do
      @action = FactoryBot.build(:action)
      @alert.actions << @action
      expect(@alert.trello).to be_a(Integration::Trello)
      expect(@alert.trello.name).to eq('Our Awesome Test Trello')
    end

    it 'can access the trello integration directly' do
      @action = FactoryBot.build(:action)
      @alert.actions << @action
      expect(@alert.trello).to be_a(Integration::Trello)
      expect(@alert.trello.name).to eq('Our Awesome Test Trello')
    end

    it 'can access the slack and trello integration directly' do
      @action_a = FactoryBot.build(:action, :as_email)
      @action_b = FactoryBot.build(:action)
      @alert.actions << @action_a
      @alert.actions << @action_b
      expect(@alert.trello).to be_a(Integration::Trello)
      expect(@alert.trello.name).to eq('Our Awesome Test Trello')
      expect(@alert.email).to be_a(Integration::Email)
      expect(@alert.email.name).to eq('Test Email Integration')
    end
  end
end