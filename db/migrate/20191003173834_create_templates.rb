# frozen_string_literal: true

class CreateTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :templates do |t|
      t.references :alert, null: false, index: true
      t.string :type, null: false
      t.integer :body_format, default: 0, null: false
      t.text :encrypted_body
      t.string :encrypted_body_iv
      t.timestamps
    end
    add_index :templates, :encrypted_body_iv, unique: true
  end
end
