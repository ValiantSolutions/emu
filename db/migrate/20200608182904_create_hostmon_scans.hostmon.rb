# This migration comes from hostmon (originally 20200608170209)
class CreateHostmonScans < ActiveRecord::Migration[6.0]
  def change
    create_table :hostmon_scans do |t|
      t.references :tag, index: true, null: false
      t.integer :status, null: false, default: 0
      t.timestamps
    end
  end
end
