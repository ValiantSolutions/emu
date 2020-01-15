# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, regressor: true do
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

  describe 'model methods' do
    it 'creates workers on save' do
      Sidekiq::Cron::Job.destroy_all!
      @task = FactoryBot.create(:failed_job)
      expect(@task).to be_valid
    end

    it 'can enqueue the worker' do
      @task = FactoryBot.create(:failed_job)
      expect(@task.enqueue).to be_truthy
    end

    it 'can get its last execution time' do
      @task = FactoryBot.create(:failed_job)
      expect(@task.last_execution_time).to eq(Sidekiq::Cron::Job.find(@task.uid).last_enqueue_time)
    end
  end
end