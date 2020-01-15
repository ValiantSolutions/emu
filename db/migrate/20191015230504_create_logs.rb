class CreateLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :logs do |t|
      t.references :job, null: false
      t.references :loggable, polymorphic: true
      t.string :encrypted_subject
      t.string :encrypted_subject_iv
      t.text :encrypted_body, limit: 16.megabytes - 1
      t.string :encrypted_body_iv
      t.timestamps
    end
    add_index :logs, :encrypted_body_iv, unique: true
    add_index :logs, :encrypted_subject_iv, unique: true
  end
end
