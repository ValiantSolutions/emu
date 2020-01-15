# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Integration::Email, regressor: true do
  # === Relations ===

  it { is_expected.to have_many :actions }
  it { is_expected.to have_many :alerts }
  it { is_expected.to have_many :logs }

  # === Nested Attributes ===

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :encrypted_host }
  it { is_expected.to have_db_column :encrypted_host_iv }
  it { is_expected.to have_db_column :encrypted_user }
  it { is_expected.to have_db_column :encrypted_user_iv }
  it { is_expected.to have_db_column :encrypted_password }
  it { is_expected.to have_db_column :encrypted_password_iv }
  it { is_expected.to have_db_column :port }
  it { is_expected.to have_db_column :ssl }
  it { is_expected.to have_db_column :body_format }
  it { is_expected.to have_db_column :authentication }
  it { is_expected.to have_db_column :encrypted_from }
  it { is_expected.to have_db_column :encrypted_from_iv }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ['encrypted_host_iv'] }
  it { is_expected.to have_db_index ['encrypted_user_iv'] }
  it { is_expected.to have_db_index ['encrypted_password_iv'] }
  it { is_expected.to have_db_index ['encrypted_from_iv'] }

  # === Enums ===
  it { is_expected.to define_enum_for(:authentication).with_values(%w[plain login cram_md5 auth_disabled]) }
  it { is_expected.to define_enum_for(:body_format).with_values(%w[plaintext html]) }

  describe 'email test functions' do
    before(:each) do
      @integration_email = FactoryBot.create(:integration_email)
    end

    it 'builds the connection' do
      expect(@integration_email.connection).to_not eq(nil)
    end

    it 'sends a test email' do
      expect do
        @integration_email.send_test_email('test@test.com')
      end.to raise_exception(Net::SMTPAuthenticationError)
    end

    it 'sends an email or raises exception' do
      expect do
        @integration_email.send_email('test@test.com', 'subject', 'body')
      end.to raise_exception(Net::SMTPAuthenticationError)
    end
  end
end