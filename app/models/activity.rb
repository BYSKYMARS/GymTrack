class Activity < ApplicationRecord
  has_many :user_activities
  has_many :class_schedules
  has_many :class_sessions

end
