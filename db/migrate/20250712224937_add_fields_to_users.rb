class AddFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :role, :integer, default: 1, null: false
    add_reference :users, :gym_location, null: false, foreign_key: true
    add_reference :users, :plan, foreign_key: true
  end
end
