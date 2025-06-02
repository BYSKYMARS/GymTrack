class Activity < ApplicationRecord
    validates :name, :category, presence: true

    has_many :user_activities, dependent: :destroy
end
