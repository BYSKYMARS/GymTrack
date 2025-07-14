class User < ApplicationRecord
  # Devise (agrega los módulos que uses)
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Relaciones
  belongs_to :gym_location
  belongs_to :plan, optional: true

  has_many :payments, dependent: :destroy
  has_many :user_activities, dependent: :destroy
  has_many :activities, through: :user_activities

  has_many :reservations, dependent: :destroy
  has_many :attendances, dependent: :destroy

  # Validaciones
  validates :name, presence: true
  validates :role, presence: true, inclusion: { in: [0, 1] }


  # Métodos de rol (sin usar enum)
  def ceo?
    role == 0
  end

  def user?
    role == 1
  end
end
