# frozen_string_literal: true

class CreateGuards < ActiveRecord::Migration[6.0]
  def change
    create_table :guards do |t|
      t.references :conditional, null: false, index: true
      t.string :doc_hash, null: false
      t.integer :hits, limit: 8, unsigned: true, default: 0, null: false
      t.timestamps
    end
    add_index :guards, %i[conditional_id doc_hash], unique: true
  end
end
