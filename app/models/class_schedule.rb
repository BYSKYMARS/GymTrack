class ClassSchedule < ApplicationRecord
  belongs_to :activity
  belongs_to :room
  belongs_to :trainer, class_name: 'StaffMember'

  has_many :class_sessions

  validates :weekday, :start_time, :end_time, presence: true

  # ✅ Genera o encuentra la sesión más próxima y reserva al usuario
  def generate_next_session_and_reserve(user)
    return :no_active_plan unless user.plan.present?
    # 1. Calcular próxima fecha del día `weekday` (0: domingo ... 6: sábado)
    today = Date.today
    days_until = (weekday - today.wday) % 7
    days_until = 7 if days_until == 0 # Solo futuro
    next_date = today + days_until

    # 2. Crear o buscar una ClassSession para ese horario
    starts_at = Time.zone.local(next_date.year, next_date.month, next_date.day, start_time.hour, start_time.min)
    ends_at = Time.zone.local(next_date.year, next_date.month, next_date.day, end_time.hour, end_time.min)

    session = ClassSession.find_or_create_by!(
      class_schedule: self,
      activity: activity,
      room: room,
      trainer: trainer,
      starts_at: starts_at,
      ends_at: ends_at,
      max_participants: 20 # puedes usar self.capacity si lo defines
    )

    # 3. Verificar si ya está reservado
    if session.reservations.exists?(user: user)
      return :already_reserved
    end

    if session.reservations.count >= session.max_participants
      return :full
    end

    # 4. Crear la reserva
    session.reservations.create!(
      user: user,
      status: 'booked',
      booked_at: Time.zone.now
    )

    return :success
  end
end
