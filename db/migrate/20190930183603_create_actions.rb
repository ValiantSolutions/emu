# frozen_string_literal: true

class CreateActions < ActiveRecord::Migration[6.0]
  def change
    create_table :actions do |t|
      t.references :alert, null: false, index: true
      t.references :integratable, polymorphic: true
      t.boolean :enabled, default: 1, null: false
      t.timestamps
    end
    add_index :actions,
              %i[
                alert_id
                integratable_type
                integratable_id
              ],
              unique: true,
              name: 'alert_integratable_id_type'
  end
end
