class CreateUserActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :user_activities do |t|
      t.references :user, null: false, foreign_key: true
      t.references :activity, null: false, foreign_key: true
      t.integer :duration
      t.date :date
      t.integer :calories_burned
      t.text :notes

      t.timestamps
    end
  end
end
