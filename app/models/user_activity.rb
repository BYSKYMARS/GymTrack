class UserActivity < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  validates :duration, :date, presence: true
end
