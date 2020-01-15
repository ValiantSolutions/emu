class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.integer :scroll_size, default: 500, null: false
      t.integer :debug_result_count, default: 5, null: false
      t.integer :inactive_account_age, default: 30, null: false
      t.integer :job_history_age, default: 90, null: false
      t.timestamps
    end
  end
end
