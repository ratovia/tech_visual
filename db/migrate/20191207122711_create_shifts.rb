class CreateShifts < ActiveRecord::Migration[5.2]
  def change
    create_table :shifts do |t|
      t.references :work_role, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamp :shift_in_at, null: false
      t.timestamp :shift_out_at, null: false
      t.timestamps
    end
  end
end
