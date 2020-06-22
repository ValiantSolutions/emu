# This migration comes from hostmon (originally 20200608172159)
class CreateHostmonAlerts < ActiveRecord::Migration[6.0]
  def change
    create_table :hostmon_alerts do |t|
      t.references :template, index: true, null: false
      t.references :scan, index: true, null: false
      t.references :compared_scan, index: true, null: false, foreign_key: { to_table: 'hostmon_scans' }
      t.integer :status, null: false, default: 0
      t.text :encrypted_body
      t.string :encrypted_body_iv
      t.string :encrypted_token, null: false
      t.string :encrypted_token_iv, null: false
      t.string :encrypted_acknowledged_by
      t.string :encrypted_acknowledged_by_iv, null: false
      t.datetime :acknowledged_at
      t.timestamps
    end
    add_index :hostmon_alerts, :encrypted_body_iv, unique: true
    add_index :hostmon_alerts, :encrypted_token_iv, unique: true
    add_index :hostmon_alerts, :encrypted_acknowledged_by_iv, unique: true
  end
end
