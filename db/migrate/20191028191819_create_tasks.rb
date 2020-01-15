class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :type, null: false
      t.string :cron, null: false, default: '*/30 * * * *'
      t.boolean :enabled, default: 1, null: false
      #t.timestamp :last_executed_at
      t.timestamps
    end
    add_index :tasks, :type, unique: true
  end
end
