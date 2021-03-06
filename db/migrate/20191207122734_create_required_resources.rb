class CreateRequiredResources < ActiveRecord::Migration[5.2]
  def change
    create_table :required_resources do |t|
      t.integer :what_day, null: false, index: true
      t.integer :clock_at, null: false, index: true
      t.integer :count, null: false
      t.references :work_role, null: false, foreign_key: true
      t.timestamps
    end
  end
end
