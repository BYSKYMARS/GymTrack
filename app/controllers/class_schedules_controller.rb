class ClassSchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_ceo!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_form_collections, only: [:new, :edit, :create, :update]

  before_action :set_class_schedule, only: %i[ show edit update destroy ]

  # GET /class_schedules or /class_schedules.json
  def index
    @activities = Activity.all
    @class_schedules = ClassSchedule
      .includes(:activity, :room, :trainer)
      .joins(room: :gym_location)
      .where(gym_locations: { id: current_user.gym_location_id })
      .order(:weekday, :start_time)
      @class_schedules = @class_schedules.where(activity_id: params[:activity_id]) if params[:activity_id].present?
      @class_schedules = @class_schedules.where(weekday: params[:weekday]) if params[:weekday].present?
  end

  def reserve
    schedule = ClassSchedule.find(params[:id])
    result = schedule.generate_next_session_and_reserve(current_user)
  
    case result
    when :no_active_plan
      redirect_to plans_path, alert: "Necesitas tener un plan activo para inscribirte en clases."
    when :already_reserved
      redirect_to class_schedules_path, alert: "Ya estás inscrito en la próxima clase."
    when :full
      redirect_to class_schedules_path, alert: "La clase está llena."
    when :success
      redirect_to class_sessions_path, notice: "Inscripción exitosa para la próxima clase."
    else
      redirect_to class_schedules_path, alert: "Ocurrió un error inesperado."
    end
  end
  
  

  # GET /class_schedules/1 or /class_schedules/1.json
  def show
  end

  # GET /class_schedules/new
  def new
    @class_schedule = ClassSchedule.new
    @trainers = StaffMember.all
    @activities = Activity.all
    @rooms = Room.all
  end

  # GET /class_schedules/1/edit
  def edit
    @trainers = StaffMember.all
    @activities = Activity.all
    @rooms = Room.all
  end

  # POST /class_schedules or /class_schedules.json
  def create
    @class_schedule = ClassSchedule.new(class_schedule_params)

    respond_to do |format|
      if @class_schedule.save
        format.html { redirect_to @class_schedule, notice: "Class schedule was successfully created." }
        format.json { render :show, status: :created, location: @class_schedule }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @class_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /class_schedules/1 or /class_schedules/1.json
  def update
    respond_to do |format|
      if @class_schedule.update(class_schedule_params)
        format.html { redirect_to @class_schedule, notice: "Class schedule was successfully updated." }
        format.json { render :show, status: :ok, location: @class_schedule }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @class_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /class_schedules/1 or /class_schedules/1.json
  def destroy
    @class_schedule.destroy!

    respond_to do |format|
      format.html { redirect_to class_schedules_path, status: :see_other, notice: "Class schedule was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_class_schedule
      @class_schedule = ClassSchedule.find(params[:id])
    end
    def set_form_collections
      @trainers = StaffMember.all
      @activities = Activity.all
      @rooms = Room.all
    end
    
    def authorize_ceo!
      unless current_user&.ceo?
        redirect_to authenticated_root_path, alert: "Acceso denegado"
      end    
    end

    # Only allow a list of trusted parameters through.
    def class_schedule_params
      params.require(:class_schedule).permit(:activity_id, :room_id, :trainer_id, :weekday, :start_time, :end_time)
    end
    
end
