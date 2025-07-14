class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :class_session

  validates :attended_at, presence: true
end
