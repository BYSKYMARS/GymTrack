class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  validates :status, presence: true
  validates :amount_paid, numericality: { greater_than_or_equal_to: 0 }
  validates :paid_on, presence: true
  validates :expires_on, presence: true
end
