class CreateCheckBoxes < ActiveRecord::Migration[5.2]
  def change
    create_table :check_boxes do |t|
      t.string :name, null: false
      t.boolean :checked, null: false, default: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
