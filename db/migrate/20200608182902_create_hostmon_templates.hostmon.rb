# This migration comes from hostmon (originally 20200608165001)
class CreateHostmonTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :hostmon_templates do |t|
      t.references :tag, null: false, index: true
      
      t.text :encrypted_body
      t.string :encrypted_body_iv
      
      t.timestamps
    end
    add_index :hostmon_templates, :encrypted_body_iv, unique: true
  end
end
