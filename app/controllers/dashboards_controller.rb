class DashboardsController < ApplicationController
  before_action :authenticate_user!



  def redirect_by_role
    if current_user.ceo?
      redirect_to ceo_dashboard_path
    else
      redirect_to users_dashboard_path
    end
  end

  
  def ceo
    redirect_to users_dashboard_path unless current_user.ceo?
  
    @users_count = User.count
    @activities_count = Activity.count
    @payments_count = Payment.count
    @total_earnings = Payment.sum(:amount_paid)
  
    # Clases más populares (top 5 actividades con más reservas)
    @popular_activities = Activity
      .joins(class_sessions: :reservations)
      .group('activities.id')
      .order('COUNT(reservations.id) DESC')
      .limit(5)
      .select('activities.*, COUNT(reservations.id) as reservation_count')
  
    # Reporte de ocupación
    @full_classes = ClassSession
      .joins(:reservations)
      .group(:id)
      .select { |s| s.reservations.size >= s.max_participants }

    @empty_classes = ClassSession
      .left_outer_joins(:reservations)
      .group(:id)
      .select { |s| s.reservations.empty? }

  
    # Entrenadores por sede
    @trainers_per_location = StaffMember
      .group(:gym_location_id)
      .count
  end
  
  
  def user
    @next_classes = current_user.reservations
                      .joins(:class_session)
                      .where(status: 'booked')
                      .where("class_sessions.starts_at > ?", Time.zone.now)
                      .includes(class_session: [:activity, :room, :trainer])
                      .order("class_sessions.starts_at ASC")
                      .limit(5)
                      @plan = current_user.plan
                      @last_payment = current_user.payments.order(paid_on: :desc).first
                      
  end
  
  
  


  
end
