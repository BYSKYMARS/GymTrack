class Room < ApplicationRecord
  belongs_to :gym_location
  has_many :class_schedules
  has_many :class_sessions

  validates :name, presence: true
  validates :capacity, numericality: { only_integer: true, greater_than: 0 }
end
