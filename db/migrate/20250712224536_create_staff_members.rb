class CreateStaffMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :staff_members do |t|
      t.string :name
      t.string :email
      t.string :role
      t.references :gym_location, null: false, foreign_key: true

      t.timestamps
    end
  end
end
