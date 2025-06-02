require 'faker'

puts "Creando planes..."
Plan.destroy_all
plans = [
  {name: "Plan Básico", price: 20.0, duration: 30, description: "Acceso básico por 1 mes"},
  {name: "Plan Standard", price: 50.0, duration: 90, description: "Acceso estándar por 3 meses"},
  {name: "Plan Premium", price: 90.0, duration: 180, description: "Acceso premium por 6 meses"},
  {name: "Plan Anual", price: 150.0, duration: 365, description: "Acceso anual completo"},
  {name: "Plan VIP", price: 300.0, duration: 730, description: "Acceso VIP por 2 años"}
].map { |attrs| Plan.create!(attrs) }

puts "Creando actividades..."
Activity.destroy_all
activities = [
  {name: "Cinta para correr", category: "Cardio"},
  {name: "Spinning", category: "Cardio"},
  {name: "Natación", category: "Cardio"},
  {name: "Entrenamiento con pesas", category: "Fuerza"},
  {name: "Yoga", category: "Flexibilidad"},
  {name: "Pilates", category: "Flexibilidad"},
  {name: "Zumba", category: "Cardio"},
  {name: "Entrenamiento HIIT", category: "Cardio"},
  {name: "Boxeo", category: "Fuerza"},
  {name: "Estiramientos", category: "Flexibilidad"}
].map { |attrs| Activity.create!(attrs) }

puts "Creando usuarios..."
User.destroy_all
users = []

1000.times do |i|
  users << User.create!(
    email: "usuario#{i+1}@gymtrack.com",
    password: "123456",
    password_confirmation: "123456",
    name: Faker::Name.name,
    role: 0,
    plan: plans.sample,
    created_at: Faker::Date.between(from: 2.years.ago, to: Date.today)
  )
end

puts "Creando usuario CEO..."
User.create!(
  email: "ceo@gymtrack.com",
  password: "ceo123456",
  password_confirmation: "ceo123456",
  name: "CEO GymTrack",
  role: 1,
  created_at: Faker::Date.between(from: 2.years.ago, to: Date.today)
)

puts "Creando pagos..."
Payment.destroy_all
payments = []

users.each do |user|
  # Cada usuario tiene al menos un pago activo del plan asignado
  payment_date = Faker::Date.between(from: user.created_at, to: Date.today)
  expires_on = payment_date + user.plan.duration.days

  payments << Payment.create!(
    user: user,
    plan: user.plan,
    amount_paid: user.plan.price,
    paid_on: payment_date,
    expires_on: expires_on,
    status: "active"
  )
end

puts "Creando actividades de usuario..."
UserActivity.destroy_all

users.each do |user|
  activities_count = rand(5..20)  # Entre 5 y 20 actividades por usuario

  activities_count.times do
    activity = activities.sample
    # Fecha de la actividad entre la creación del usuario y hoy
    activity_date = Faker::Date.between(from: user.created_at, to: Date.today)

    UserActivity.create!(
      user: user,
      activity: activity,
      duration: rand(10..120), # Duración entre 10 y 120 minutos
      date: activity_date,
      calories_burned: rand(50..1000),
      notes: Faker::Lorem.sentence(word_count: 5)
    )
  end
end

puts "Seed completado!"
