# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task::PruneJobHistory, regressor: true do
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
      @prune_job_history = FactoryBot.create(:prune_job_history)
    end

    describe 'validates template' do
      it 'has a valid factory' do
        expect(@prune_job_history).to be_valid
      end
    end

    describe 'uses single table inheritance' do
      it 'is the child of Task' do
        expect(@prune_job_history.type).to eq('Task::PruneJobHistory')
        expect(@prune_job_history).to be_a(Task)
      end
    end

    describe 'constantizes worker class' do
      it 'is an InactiveAccountWorker' do
        expect(@prune_job_history.worker.new).to be_a(PruneJobHistoryWorker)
      end
    end
  end
  # === Enums ===
end