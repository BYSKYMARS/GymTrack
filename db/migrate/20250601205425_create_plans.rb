class CreatePlans < ActiveRecord::Migration[8.0]
  def change
    create_table :plans do |t|
      t.string :name
      t.decimal :price
      t.integer :duration
      t.text :description

      t.timestamps
    end
  end
end
