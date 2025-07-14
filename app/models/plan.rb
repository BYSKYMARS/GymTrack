class Plan < ApplicationRecord
    has_many :users
    has_many :payments
    VALID_DURATIONS = [1, 3, 6, 12]

    
    validates :name, presence: true
    validates :price, numericality: { greater_than_or_equal_to: 0 }
    validates :duration, inclusion: { in: VALID_DURATIONS, message: "debe ser 1, 3, 6 o 12 meses" }
end
   
