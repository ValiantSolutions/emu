# frozen_string_literal: true

class CreateIntegrationSlacks < ActiveRecord::Migration[6.0]
  def change
    create_table :integration_slacks do |t|
      t.string :name, null: false
      t.string :encrypted_channels, null: false
      t.string :encrypted_channels_iv, null: false
      t.string :encrypted_secret_iv, null: false
      t.string :encrypted_secret, null: false
      t.integer :status, null: false, default: 0
      t.timestamps
    end
    add_index :integration_slacks, :encrypted_channels_iv, unique: true
    add_index :integration_slacks, :encrypted_secret_iv, unique: true
  end
end
