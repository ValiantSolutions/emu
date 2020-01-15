# frozen_string_literal: true

class CreateAlerts < ActiveRecord::Migration[6.0]
  def change
    create_table :alerts do |t|
      t.references :user, null: false, index: true
      t.string :type, null: false
      t.string :name, null: false
      t.references :search, null: false, index: true
      t.integer :deduplication, default: 0, null: false
      t.string :deduplication_fields

      t.timestamps
    end
  end
end
