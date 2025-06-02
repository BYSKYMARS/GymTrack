class DashboardsController < ApplicationController
  def ceo
    @total_users = User.count
    @active_payments = Payment.where("expires_on >= ?", Date.today).count
    @total_income = Payment.sum(:amount_paid)
    @most_active_users = User.joins(:user_activities).group(:id).order("COUNT(user_activities.id) DESC").limit(5)
  end

  def user
    @interval = params[:interval] || "day"
    @metric = params[:metric] || "calories_burned"
    @activity_id = params[:activity_id].presence
    @date_param = params[:date].presence || Date.today.to_s
  
    case @interval
    when "day"
      @date = Date.parse(@date_param)
      start_time = @date.beginning_of_day
      end_time = @date.end_of_day
    when "week"
      # La fecha de inicio de la semana que el usuario seleccionó
      @week_start = Date.parse(@date_param)
      start_time = @week_start.beginning_of_day
      end_time = (@week_start + 6.days).end_of_day
    when "month"
      year = params[:year].presence || Date.today.year
      month = params[:month].presence || Date.today.month
      start_time = Date.new(year.to_i, month.to_i, 1)
      end_time = start_time.end_of_month
    when "year"
      year = params[:year].presence || Date.today.year
      start_time = Date.new(year.to_i, 1, 1)
      end_time = start_time.end_of_year
    else
      @interval = "day"
      @date = Date.parse(@date_param)
      start_time = @date.beginning_of_day
      end_time = @date.end_of_day
    end
  
    activities_scope = current_user.user_activities.where(date: start_time..end_time)
    activities_scope = activities_scope.where(activity_id: @activity_id) if @activity_id
  
    if @interval == "day"
      @duration_data = activities_scope.group(:activity_id).sum(:duration).transform_keys { |id| Activity.find_by(id: id)&.name || "Desconocida" }
      @calories_data = activities_scope.group(:activity_id).sum(:calories_burned).transform_keys { |id| Activity.find_by(id: id)&.name || "Desconocida" }
    else
      case @interval
      when "week", "month"
        # Agrupamos por día
        @chart_data = activities_scope.group_by_day(:date).sum(@metric)
      when "year"
        @chart_data = activities_scope.group_by_month(:date, format: "%b").sum(@metric)
      end
    end
  
    @calories_total = activities_scope.sum(:calories_burned)
    @minutes_total = activities_scope.sum(:duration)
    @activities = Activity.all.order(:name)
    @user_activities = current_user.user_activities.order(date: :desc).limit(10)
  end  
  
end
