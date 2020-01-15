# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :avatar_url
      t.string :email, null: false
      t.boolean :admin, default: 0, null: false
      t.string :uid
      t.string :oauth_token
      t.string :provider
      t.datetime :remember_created_at

      # approvable
      t.boolean :approved, default: false, null: false

      # database authenticatable
      t.string :encrypted_password, null: false, default: ''

      # two_factor_authenticatable
      # t.string :google_secret
      # t.integer :second_factor_attempts_count
      # t.string :encrypted_otp_secret_key
      # t.string :encrypted_otp_secret_key_iv
      # t.string :encrypted_otp_secret_key_salt
      # t.string :direct_otp
      # t.datetime :direct_otp_sent_at 
      # t.timestamp :totp_timestamp

      # recoverable
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      # lockable
      t.integer :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      ## trackable
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :unlock_token, unique: true
  end
end
