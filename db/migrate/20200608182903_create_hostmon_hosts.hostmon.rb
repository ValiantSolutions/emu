# This migration comes from hostmon (originally 20200608165505)
class CreateHostmonHosts < ActiveRecord::Migration[6.0]
  def change
    create_table :hostmon_hosts do |t|
      t.references :scan, index: true, null: false
      t.string :encrypted_address
      t.string :encrypted_address_iv
      t.timestamps
    end
    add_index :hostmon_hosts, :encrypted_address_iv, unique: true
  end
end
