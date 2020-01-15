require 'rails_helper'

RSpec.describe User, regressor: true do

  # === Relations ===
  
  
  it { is_expected.to have_many :searches }
  it { is_expected.to have_many :elastic_endpoints }

  # === Nested Attributes ===
  

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :username }
  it { is_expected.to have_db_column :avatar_url }
  it { is_expected.to have_db_column :email }
  it { is_expected.to have_db_column :admin }
  it { is_expected.to have_db_column :uid }
  it { is_expected.to have_db_column :oauth_token }
  it { is_expected.to have_db_column :provider }
  it { is_expected.to have_db_column :remember_created_at }
  it { is_expected.to have_db_column :approved }
  it { is_expected.to have_db_column :encrypted_password }
  it { is_expected.to have_db_column :reset_password_token }
  it { is_expected.to have_db_column :reset_password_sent_at }
  it { is_expected.to have_db_column :failed_attempts }
  it { is_expected.to have_db_column :unlock_token }
  it { is_expected.to have_db_column :locked_at }
  it { is_expected.to have_db_column :sign_in_count }
  it { is_expected.to have_db_column :current_sign_in_at }
  it { is_expected.to have_db_column :last_sign_in_at }
  it { is_expected.to have_db_column :current_sign_in_ip }
  it { is_expected.to have_db_column :last_sign_in_ip }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }
  it { is_expected.to have_db_column :encrypted_otp_secret }
  it { is_expected.to have_db_column :encrypted_otp_secret_iv }
  it { is_expected.to have_db_column :encrypted_otp_secret_salt }
  it { is_expected.to have_db_column :otp_required_for_login }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["email"] }
  it { is_expected.to have_db_index ["reset_password_token"] }
  it { is_expected.to have_db_index ["unlock_token"] }

  # === Validations (Length) ===
  

  # === Validations (Presence) ===
  context "with conditions" do
    before do
      allow(subject).to receive(:password?).and_return(true)
    end

    it { is_expected.to validate_presence_of(:password).with_message('Password field must be present.') }
      it { is_expected.to validate_presence_of(:password_confirmation).with_message('Password field must be present.') }
  end


  # === Validations (Numericality) ===
  

  
  # === Enums ===
  
  
end