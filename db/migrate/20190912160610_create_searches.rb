# frozen_string_literal: true

class CreateSearches < ActiveRecord::Migration[6.0]
  def change
    create_table :searches do |t|
      t.references :user, null: false, index: true
      t.references :elastic_endpoint, null: false, index: true

      t.string :name, null: false

      t.text :encrypted_indices
      t.string :encrypted_indices_iv
      t.text :encrypted_query, null: false
      t.string :encrypted_query_iv

      t.boolean :permanent, default: 0, null: false
      t.timestamps
    end
    add_index :searches, :encrypted_query_iv, unique: true
    add_index :searches, :encrypted_indices_iv, unique: true
  end
end
