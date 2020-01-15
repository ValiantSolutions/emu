# frozen_string_literal: true

class CreateIntegrationEmails < ActiveRecord::Migration[6.0]
  def change
    create_table :integration_emails do |t|
      t.string :name, null: false
      t.string :encrypted_host, null: false
      t.string :encrypted_host_iv, null: false
      t.string :encrypted_user
      t.string :encrypted_user_iv, null: false
      t.string :encrypted_password
      t.string :encrypted_password_iv, null: false
      t.integer :port, null: false
      t.boolean :ssl, null: false, default: 1
      t.integer :body_format, null: false, default: 0
      t.integer :authentication, null: false, default: 1
      t.string :encrypted_from, null: false
      t.string :encrypted_from_iv, null: false
      t.timestamps
    end
    add_index :integration_emails, :encrypted_host_iv, unique: true
    add_index :integration_emails, :encrypted_user_iv, unique: true
    add_index :integration_emails, :encrypted_password_iv, unique: true
    add_index :integration_emails, :encrypted_from_iv, unique: true
  end
end