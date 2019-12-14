class CreateAttendances < ActiveRecord::Migration[5.2]
  def change
    create_table :attendances do |t|
      t.date :date, null: false
      t.integer :attendance_at, null: false
      t.integer :leaving_at, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
