class GymLocation < ApplicationRecord
  belongs_to :city
  has_many :rooms
  has_many :users
  has_many :staff_members

end
