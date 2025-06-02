class Plan < ApplicationRecord
    has_many :payments, dependent: :nullify
    validates :name, :price, :duration, presence: true
end
