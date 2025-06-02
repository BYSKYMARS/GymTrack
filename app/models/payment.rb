class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  validates :amount_paid, :paid_on, :expires_on, presence: true
end
