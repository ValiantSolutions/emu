# frozen_string_literal: true

class CreateElasticEndpoints < ActiveRecord::Migration[6.0]
  def change
    create_table :elastic_endpoints do |t|
      t.references :user, null: false, index: true
      t.string :name, null: false
      t.integer :status, null: false, default: 0
      t.integer :protocol, null: false
      t.boolean :verify_ssl, null: false, default: 1
      t.integer :port, null: false
      t.string :encrypted_address
      t.string :encrypted_username
      t.string :encrypted_password
      t.string :encrypted_address_iv
      t.string :encrypted_username_iv
      t.string :encrypted_password_iv
      t.timestamps
    end
    add_index :elastic_endpoints, :encrypted_address_iv, unique: true
    add_index :elastic_endpoints, :encrypted_username_iv, unique: true
    add_index :elastic_endpoints, :encrypted_password_iv, unique: true
  end
end
