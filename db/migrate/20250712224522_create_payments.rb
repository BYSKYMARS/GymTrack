class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :plan, null: false, foreign_key: true
      t.decimal :amount_paid
      t.date :paid_on
      t.date :expires_on
      t.string :status

      t.timestamps
    end
  end
end
