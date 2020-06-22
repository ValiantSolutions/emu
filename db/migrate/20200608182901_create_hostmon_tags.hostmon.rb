# This migration comes from hostmon (originally 20200608163819)
class CreateHostmonTags < ActiveRecord::Migration[6.0]
  def change
    create_table :hostmon_tags do |t|
      t.references :elastic_endpoint
      t.string :encrypted_query
      t.string :encrypted_query_iv
      t.string :cron, null: false, default: '*/15 * * * *'
      t.integer :compare_period, null: false, default: 1440
      
      t.timestamps
    end
    add_index :hostmon_tags, :encrypted_query_iv, unique: true
  end
end
