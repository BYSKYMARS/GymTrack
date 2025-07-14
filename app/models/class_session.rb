class ClassSession < ApplicationRecord
  belongs_to :class_schedule
  belongs_to :activity
  belongs_to :room
  belongs_to :trainer, class_name: "StaffMember"

  has_many :reservations
  has_many :attendances

# Atributos:
# starts_at:datetime
# ends_at:datetime
# max_participants:integer

end
