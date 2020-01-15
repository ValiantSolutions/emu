class CreateSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :schedules do |t|
      t.references :user, null: false, index: true
      t.string :cron, null: false, default: '*/15 * * * *'
      t.integer :range, null: false, default: 20
      t.integer :period, null: false, default: 0
      t.belongs_to :alert, null: false, foreign_key: true
      t.boolean :enabled, default: 1, null: false
      t.timestamps
    end
    add_index :schedules, %i[alert_id cron], unique: true
  end
end
