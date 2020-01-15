# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Template, type: :model do
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

    @conditional = @alert.conditional
    @payload = @alert.payload
  end

  describe 'validates template' do
    it 'has valid factories' do
      expect(@conditional).to be_valid
      expect(@payload).to be_valid
    end
  end

  describe 'template validations' do
    it 'throws an error for an invalid template' do
      @alert.conditional.body = '{% beh%%%% }}'
      expect(@alert.conditional.save).to be_falsy
      expect(@alert.conditional.parse).to eq(nil)
    end
  end

  describe 'uses single table inheritance' do
    it 'is the parent of Conditional' do
      expect(@conditional.type).to eq('Conditional')
      expect(@conditional).to be_a(Conditional)
      expect(@conditional).to be_a(Template)
    end

    it 'is the parent of Payload' do
      expect(@payload.type).to eq('Payload')
      expect(@payload).to be_a(Payload)
      expect(@payload).to be_a(Template)
    end
  end

  describe 'validates polymorphism' do
    it 'is templatable' do
      expect(@conditional.alert.search).to_not eq(nil)
      expect(@payload.alert.search).to_not eq(nil)
    end
  end
end