# frozen_string_literal: true

class CreateJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :jobs do |t|
      t.timestamp :from
      t.timestamp :to
      
      t.string :bid
      t.text :encrypted_raw_query
      t.string :encrypted_raw_query_iv
      t.text :details
      t.references :alert, null: false, index: true
      t.references :schedule, index: true

      t.integer :status, default: 0, null: false
      t.integer :raw_event_count, limit: 8, unsigned: true, default: 0, null: false
      t.integer :actionable_event_count, limit: 8, unsigned: true, default: 0, null: false

      t.timestamps
    end
    add_index :jobs, :bid, unique: true
    add_index :jobs, :encrypted_raw_query_iv, unique: true
  end
end
