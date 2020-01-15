# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task::FailedJob, regressor: true do
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
      @failed_job = FactoryBot.create(:failed_job)
    end

    describe 'validates template' do
      it 'has a valid factory' do
        expect(@failed_job).to be_valid
      end
    end

    describe 'uses single table inheritance' do
      it 'is the child of Task' do
        expect(@failed_job.type).to eq('Task::FailedJob')
        expect(@failed_job).to be_a(Task)
      end
    end

    describe 'constantizes worker class' do
      it 'is a FailedJobWorker' do
        expect(@failed_job.worker.new).to be_a(FailedJobWorker)
      end
    end
  end
end