class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :payments, dependent: :destroy
  
  has_many :user_activities, dependent: :destroy
  has_many :activities, through: :user_activities
  
  belongs_to :plan, optional: true

  def user?
    role == 0
  end

  def ceo?
    role == 1
  end
  after_initialize :set_default_role, if: :new_record?
  def set_default_role
    self.role ||= 0
  end
  def active_plan?
    payments.where("expires_on >= ?", Date.today).where(status: "active").exists?
  end
  
  validates :name, presence: true
end
