class CreateReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :class_session, null: false, foreign_key: true
      t.string :status
      t.datetime :booked_at

      t.timestamps
    end
  end
end
