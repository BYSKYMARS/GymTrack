class StaffMember < ApplicationRecord
  belongs_to :gym_location

  has_many :class_schedules, foreign_key: :trainer_id
  has_many :class_sessions, foreign_key: :trainer_id

end
