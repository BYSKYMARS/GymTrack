require 'faker'

puts "🔄 Limpiando datos..."
Attendance.delete_all
Reservation.delete_all
ClassSession.delete_all
ClassSchedule.delete_all
UserActivity.delete_all
StaffMember.delete_all
Room.delete_all
Payment.delete_all
User.delete_all
Plan.delete_all
Activity.delete_all
GymLocation.delete_all
City.delete_all

puts "🏙️ Creando ciudades y sedes..."
peruvian_cities = %w[Lima Arequipa Trujillo Cusco Piura]
cities = peruvian_cities.map { |name| City.create!(name: name) }

gym_locations = cities.flat_map do |city|
  [1, 2].map do |i|
    GymLocation.create!(
      name: "Sede #{city.name} #{i}",
      address: Faker::Address.street_address,
      city: city
    )
  end
end

puts "🏟️ Creando salas..."
animal_names = %w[Tigre Puma León Jaguar Cóndor Zorro Lobo Oso Águila Serpiente]
rooms = gym_locations.flat_map do |location|
  [1, 2].map do
    Room.create!(
      name: "Room #{animal_names.sample}",
      capacity: rand(15..25),
      gym_location: location
    )
  end
end

puts "🪪 Creando planes..."
plans = [
  Plan.create!(name: "Básico", price: 49.99, duration: 1, description: "Acceso limitado a clases."),
  Plan.create!(name: "Estándar", price: 99.99, duration: 3, description: "Acceso general a actividades."),
  Plan.create!(name: "Premium", price: 149.99, duration: 6, description: "Acceso completo + salas VIP.")
]

puts "🏃 Creando actividades..."
categories = {
  "Cardio" => ["Cinta para correr", "Bicicleta estacionaria"],
  "Fuerza" => ["Levantamiento de pesas", "Entrenamiento funcional"],
  "Flexibilidad" => ["Yoga", "Pilates"],
  "Baile" => ["Zumba", "Salsa"],
  "Defensa personal" => ["Boxeo", "Jiu-Jitsu"]
}
activities = categories.flat_map do |category, names|
  names.map { |name| Activity.create!(name: name, category: category) }
end

puts "👨‍🏫 Creando staff (solo trainers)..."
staff_members = gym_locations.flat_map do |location|
  2.times.map do
    StaffMember.create!(
      name: Faker::Name.name,
      email: Faker::Internet.unique.email,
      role: "trainer",
      gym_location: location
    )
  end
end

puts "👤 Creando usuarios..."
users = 500.times.map do |i|
  plan = plans.sample
  User.create!(
    email: "usuario#{i + 1}@gymtrack.com",
    password: "123456",
    name: Faker::Name.name,
    role: 1,
    gym_location: gym_locations.sample,
    plan: plan
  )
end

puts "👑 Creando CEO (sin plan)..."
ceo = User.create!(
  email: "ceo@gymtrack.com",
  password: "ceo123456",
  name: "Administrador General",
  gym_location: gym_locations.sample,
  role: 0,
  plan: nil
)

puts "💵 Generando pagos históricos..."
start_date = Date.new(2022, 7, 1)
users.each do |user|
  current_date = start_date
  while current_date < Date.today
    plan = user.plan
    expires_on = current_date + plan.duration.months
    Payment.create!(
      user: user,
      plan: plan,
      amount_paid: plan.price,
      paid_on: current_date,
      expires_on: expires_on,
      status: Date.today <= expires_on ? "activo" : "inactivo"
    )
    current_date = expires_on
  end
end

puts "📅 Generando horarios fijos..."
class_schedules = []
10.times do
  class_schedules << ClassSchedule.create!(
    activity: activities.sample,
    room: rooms.sample,
    trainer: staff_members.sample,
    weekday: rand(0..6),
    start_time: "#{rand(6..19)}:00",
    end_time: "#{rand(7..21)}:00"
  )
end

puts "⏱️ Creando sesiones semanales (últimos 3 años)..."
sessions = []
class_schedules.each do |schedule|
  (0..156).each do |i| # 3 años = 156 semanas
    date = Date.today.beginning_of_week - i.weeks + schedule.weekday.days
    next if date < Date.new(2022, 7, 1)
    starts_at = DateTime.new(date.year, date.month, date.day, schedule.start_time.hour, 0)
    ends_at = DateTime.new(date.year, date.month, date.day, schedule.end_time.hour, 0)
    sessions << ClassSession.create!(
      class_schedule: schedule,
      activity: schedule.activity,
      room: schedule.room,
      trainer: schedule.trainer,
      starts_at: starts_at,
      ends_at: ends_at,
      max_participants: schedule.room.capacity
    )
  end
end

puts "📋 Creando reservas y asistencias (solo usuarios con plan activo)..."
active_users = users.select do |u|
  u.payments.order(paid_on: :desc).first&.expires_on&.>= Date.today
end

sessions.each do |session|
  attending_users = active_users.sample(rand(2..10))
  attending_users.each do |user|
    Reservation.create!(
      user: user,
      class_session: session,
      status: "confirmado",
      booked_at: session.starts_at - rand(1..5).days
    )
    Attendance.create!(
      user: user,
      class_session: session,
      attended_at: session.starts_at + rand(0..5).minutes
    )
  end
end

puts "🏋️ Generando actividades personales (UserActivity)..."
users.each do |user|
  rand(5..15).times do
    UserActivity.create!(
      user: user,
      activity: activities.sample,
      duration: rand(20..90),
      date: rand(0..900).days.ago.to_date
    )
  end
end

puts "✅ Seed generado correctamente con:"
puts "- #{cities.count} ciudades"
puts "- #{gym_locations.count} sedes"
puts "- #{rooms.count} salas"
puts "- #{plans.count} planes"
puts "- #{activities.count} actividades"
puts "- #{staff_members.count} entrenadores"
puts "- #{users.count} usuarios + 1 CEO"
puts "- #{Payment.count} pagos"
puts "- #{ClassSchedule.count} horarios"
puts "- #{ClassSession.count} sesiones"
puts "- #{Reservation.count} reservas"
puts "- #{Attendance.count} asistencias"
puts "- #{UserActivity.count} actividades personales"
