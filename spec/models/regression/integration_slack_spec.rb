require 'rails_helper'

RSpec.describe Integration::Slack, regressor: true do

  # === Relations ===
  
  
  it { is_expected.to have_many :actions }
  it { is_expected.to have_many :alerts }
  it { is_expected.to have_many :logs }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :encrypted_channels }
  it { is_expected.to have_db_column :encrypted_channels_iv }
  it { is_expected.to have_db_column :encrypted_secret_iv }
  it { is_expected.to have_db_column :encrypted_secret }
  it { is_expected.to have_db_column :status }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["encrypted_channels_iv"] }
  it { is_expected.to have_db_index ["encrypted_secret_iv"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of(:name).with_message('This field is required.')}
  it { is_expected.to validate_presence_of(:channels).with_message('This field is required.') }
  it { is_expected.to validate_presence_of(:secret).with_message('This field is required.') }

  # === Validations (Numericality) ===
  

  
  # === Enums ===
  it { is_expected.to define_enum_for(:status).with_values(["connectable", "unconnectable", "unknown"]) }

  describe 'slack test functions' do
    before(:each) do
      @integration_slack = FactoryBot.create(:integration_slack)
    end

    it 'builds the connection' do
      expect(@integration_slack.connection).to_not eq(nil)
    end

    it 'sends a test message' do
      expect do
        @integration_slack.send_test_message
      end.to raise_exception(Slack::Web::Api::Errors::SlackError)
    end

    it 'sends an email or raises exception' do
      expect do
        @integration_slack.send_message('test message!')
      end.to raise_exception(Slack::Web::Api::Errors::SlackError)
    end
  end
end