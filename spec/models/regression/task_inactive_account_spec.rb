# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task::InactiveAccount, regressor: true do
  # === Relations ===

  # === Nested Attributes ===

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :type }
  it { is_expected.to have_db_column :cron }
  it { is_expected.to have_db_column :enabled }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ['type'] }

  # === Validations (Length) ===

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of(:cron).with_message('Cron expression required.') }

  # === Validations (Numericality) ===

  context 'model' do
    before(:each) do
      @inactive_account = FactoryBot.create(:inactive_account)
    end

    describe 'validates template' do
      it 'has a valid factory' do
        expect(@inactive_account).to be_valid
      end
    end

    describe 'uses single table inheritance' do
      it 'is the child of Task' do
        expect(@inactive_account.type).to eq('Task::InactiveAccount')
        expect(@inactive_account).to be_a(Task)
      end
    end

    describe 'constantizes worker class' do
      it 'is an InactiveAccountWorker' do
        expect(@inactive_account.worker.new).to be_a(InactiveAccountWorker)
      end
    end
  end
  # === Enums ===
end