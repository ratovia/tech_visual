class CreateAssignables < ActiveRecord::Migration[5.2]
  def change
    create_table :assignables do |t|
      t.references :user, null: false, foreign_key: true
      t.references :work_role, null: false, foreign_key: true
      t.timestamps
    end
    add_index  :assignables, [:user_id, :work_role_id], unique: true
  end
end
