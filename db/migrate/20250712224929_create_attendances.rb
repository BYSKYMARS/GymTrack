class CreateAttendances < ActiveRecord::Migration[8.0]
  def change
    create_table :attendances do |t|
      t.references :user, null: false, foreign_key: true
      t.references :class_session, null: false, foreign_key: true
      t.datetime :attended_at

      t.timestamps
    end
  end
end
