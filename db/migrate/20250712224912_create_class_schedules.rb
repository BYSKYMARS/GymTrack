class CreateClassSchedules < ActiveRecord::Migration[8.0]
  def change
    create_table :class_schedules do |t|
      t.references :activity, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.references :trainer, null: false, foreign_key: { to_table: :staff_members }
      t.integer :weekday
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
