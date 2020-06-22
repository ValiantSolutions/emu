# This migration comes from hostmon (originally 20200608173746)
class CreateHostmonIgnoredHosts < ActiveRecord::Migration[6.0]
  def change
    create_table :hostmon_ignored_hosts do |t|
      t.references :tag, index: true, null: false
      t.string :encrypted_regex
      t.string :encrypted_regex_iv
      t.timestamps
    end
    add_index :hostmon_ignored_hosts, :encrypted_regex_iv, unique: true
  end
end