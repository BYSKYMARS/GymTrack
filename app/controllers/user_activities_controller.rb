class UserActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_activity, only: [:show, :edit, :update, :destroy]
  before_action :check_active_plan, only: [:new, :create]

  def index
    @user_activities = current_user.user_activities.includes(:activity).order(date: :desc)
  end

  def show
  end

  def new
    @user_activity = UserActivity.new
  end

  def create
    @user_activity = UserActivity.new(user_activity_params)
    @user_activity.user = current_user

    if @user_activity.save
      redirect_to @user_activity, notice: "Actividad registrada con éxito."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user_activity.update(user_activity_params)
      redirect_to @user_activity, notice: "Actividad actualizada con éxito."
    else
      render :edit
    end
  end

  def destroy
    @user_activity.destroy
    redirect_to user_activities_path, notice: "Actividad eliminada."
  end

  private

  def set_user_activity
    @user_activity = current_user.user_activities.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to user_activities_path, alert: "No tienes acceso a esta actividad."
  end

  def user_activity_params
    params.require(:user_activity).permit(:activity_id, :duration, :date, :calories_burned, :notes)
  end

  def check_active_plan
    unless current_user.payments.where("expires_on >= ?", Date.today).exists?
      redirect_to users_dashboard_path, alert: "Necesitas un plan activo para registrar actividades."
    end
  end
end

