# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schedule, regressor: true do
  # === Relations ===
  it { is_expected.to belong_to :alert }
  it { is_expected.to belong_to :user }

  it { is_expected.to have_many :jobs }

  # === Nested Attributes ===

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :user_id }
  it { is_expected.to have_db_column :cron }
  it { is_expected.to have_db_column :range }
  it { is_expected.to have_db_column :period }
  it { is_expected.to have_db_column :alert_id }
  it { is_expected.to have_db_column :enabled }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index %w[alert_id cron] }
  it { is_expected.to have_db_index ['alert_id'] }
  it { is_expected.to have_db_index ['user_id'] }

  # === Validations (Length) ===

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of(:alert).with_message('must exist') }
  it { is_expected.to validate_presence_of(:user).with_message('must exist') }
  it { is_expected.to validate_presence_of(:cron).with_message('Cron expression required.') }
  it { is_expected.to validate_presence_of(:range).with_message('Range must be specified') }

  # === Validations (Numericality) ===
  it { is_expected.to validate_numericality_of(:range).only_integer.with_message('Range must be an integer') }
  it { is_expected.to validate_numericality_of(:range).is_greater_than(0).with_message('Range must be an integer') }
  it { is_expected.not_to validate_numericality_of(:range).is_greater_than(-1) }
  it { is_expected.to validate_numericality_of(:range).with_message('Range must be an integer') }

  # === Enums ===
  it { is_expected.to define_enum_for(:period).with_values(%w[minutes hours days weeks months]) }

  describe 'model methods' do
    before(:each) do
      @alert = FactoryBot.build(
        :alert,
        conditional: FactoryBot.build(:conditional),
        payload: FactoryBot.build(:payload),
        search: Search.first || FactoryBot.create(:search)
      )
      @alert.actions << FactoryBot.create(:action)
      @alert.save!
      @schedule = FactoryBot.create(:schedule, alert_id: @alert.id)
    end

    it 'gets the next time' do
      expect(@schedule.next).to eq(Fugit::Cron.parse('*/5 * * * *').next_time)
    end

    it 'gets the previous time' do
      expect(@schedule.last).to eq(Fugit::Cron.parse('*/5 * * * *').previous_time)
    end

    it 'converts the range to seconds' do
      expect(@schedule.range_in_seconds).to eq(3600)
    end
  end
end