class CreateClassSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :class_sessions do |t|
      t.references :class_schedule, null: false, foreign_key: true
      t.references :activity, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.references :trainer, null: false, foreign_key: { to_table: :staff_members }
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer :max_participants

      t.timestamps
    end
  end
end
