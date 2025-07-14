class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :class_session

  validates :status, :booked_at, presence: true
end
