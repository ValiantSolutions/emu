# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Setting, regressor: true do
  # === Database (Columns) ===
  it { is_expected.to have_db_column :scroll_size }
  it { is_expected.to have_db_column :debug_result_count }
  it { is_expected.to have_db_column :inactive_account_age }
  it { is_expected.to have_db_column :job_history_age }

  
  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of(:scroll_size).with_message('Required field.') }
  it { is_expected.to validate_presence_of(:debug_result_count).with_message('Required field.') }
  it { is_expected.to validate_presence_of(:inactive_account_age).with_message('Required field.') }
  it { is_expected.to validate_presence_of(:job_history_age).with_message('Required field.') }

  # === Validations (Numericality) ===
  it { is_expected.to validate_numericality_of(:scroll_size).only_integer.with_message('Must be an integer greater than 0, and less than 10,000.') }
  it { is_expected.to validate_numericality_of(:scroll_size).is_greater_than(0).with_message('Must be an integer greater than 0, and less than 10,000.') }
  it { is_expected.not_to validate_numericality_of(:scroll_size).is_greater_than(-1) }
  it { is_expected.to validate_numericality_of(:scroll_size).with_message('Must be an integer greater than 0, and less than 10,000.') }
  it { is_expected.to validate_numericality_of(:scroll_size).is_less_than_or_equal_to(10_000).with_message('Must be an integer greater than 0, and less than 10,000.') }
  it { is_expected.not_to validate_numericality_of(:scroll_size).is_less_than_or_equal_to(10_000) }

  it { is_expected.to validate_numericality_of(:debug_result_count).only_integer.with_message('Must be an integer greater than 0, and less than 10,000.') }
  it { is_expected.to validate_numericality_of(:debug_result_count).is_greater_than(0).with_message('Must be an integer greater than 0, and less than 10,000.') }
  it { is_expected.not_to validate_numericality_of(:debug_result_count).is_greater_than(-1) }
  it { is_expected.to validate_numericality_of(:debug_result_count).with_message('Must be an integer greater than 0, and less than 10,000.') }
  it { is_expected.to validate_numericality_of(:debug_result_count).is_less_than_or_equal_to(10_000).with_message('Must be an integer greater than 0, and less than 10,000.') }
  it { is_expected.not_to validate_numericality_of(:debug_result_count).is_less_than_or_equal_to(10_000) }

  it { is_expected.to validate_numericality_of(:inactive_account_age).only_integer.with_message('Must be an integer greater than 0, and less than 10,000.') }
  it { is_expected.to validate_numericality_of(:inactive_account_age).is_greater_than(0).with_message('Must be an integer greater than 0, and less than 10,000.') }
  it { is_expected.not_to validate_numericality_of(:inactive_account_age).is_greater_than(-1) }
  it { is_expected.to validate_numericality_of(:inactive_account_age).with_message('Must be an integer greater than 0, and less than 10,000.') }
  it { is_expected.to validate_numericality_of(:inactive_account_age).is_less_than_or_equal_to(10_000).with_message('Must be an integer greater than 0, and less than 10,000.') }
  it { is_expected.not_to validate_numericality_of(:inactive_account_age).is_less_than_or_equal_to(10_000) }

  it { is_expected.to validate_numericality_of(:job_history_age).only_integer.with_message('Must be an integer greater than 0, and less than 10,000.') }
  it { is_expected.to validate_numericality_of(:job_history_age).is_greater_than(0).with_message('Must be an integer greater than 0, and less than 10,000.') }
  it { is_expected.not_to validate_numericality_of(:job_history_age).is_greater_than(-1) }
  it { is_expected.to validate_numericality_of(:job_history_age).with_message('Must be an integer greater than 0, and less than 10,000.') }
  it { is_expected.to validate_numericality_of(:job_history_age).is_less_than_or_equal_to(10_000).with_message('Must be an integer greater than 0, and less than 10,000.') }
  it { is_expected.not_to validate_numericality_of(:job_history_age).is_less_than_or_equal_to(10_000) }
  describe 'factory' do
    it 'is valid' do
      expect(FactoryBot.create(:setting)).to be_valid
    end
  end

  describe 'validations' do
    it 'throws an error if there are multiple settings' do
      @setting = FactoryBot.create(:setting)

      @setting2 = FactoryBot.create(:setting)
      expect(@setting.valid?).to be_falsy
    end
  end
end