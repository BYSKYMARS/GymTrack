class CreateGymLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :gym_locations do |t|
      t.string :name
      t.string :address
      t.references :city, null: false, foreign_key: true

      t.timestamps
    end
  end
end
