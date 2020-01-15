class CreateIntegrationTrellos < ActiveRecord::Migration[6.0]
  def change
    create_table :integration_trellos do |t|
      t.string :name, null: false
      t.string :encrypted_token, null: false
      t.string :encrypted_token_iv, null: false
      t.string :encrypted_secret_iv, null: false
      t.string :encrypted_secret, null: false
      t.string :encrypted_board_id, null: false
      t.string :encrypted_board_id_iv, null: false
      t.boolean :create_labels, default: 1, null: false
      t.boolean :create_lists, default: 1, null: false
      t.integer :card_duplication, default: 0, null: false
      t.timestamps
    end
    add_index :integration_trellos, :encrypted_secret_iv, unique: true
    add_index :integration_trellos, :encrypted_token_iv, unique: true
    add_index :integration_trellos, :encrypted_board_id_iv, unique: true
  end
end
