class ClassSessionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_ceo!, only: [:new, :create, :edit, :update, :destroy]

  before_action :set_class_session, only: %i[ show edit update destroy ]
  before_action :set_class_session, only: [:reserve, :cancel]

  # GET /class_sessions or /class_sessions.json
  def index
    @activities = Activity.all
    @class_sessions = ClassSession
    .includes(:activity, :room, :trainer)
    .joins(room: :gym_location)
    .where('starts_at >= ?', Time.zone.now)
    .where(gym_locations: { id: current_user.gym_location_id })

  # Filtros opcionales
  @class_sessions = @class_sessions.where(activity_id: params[:activity_id]) if params[:activity_id].present?
  @class_sessions = @class_sessions.where("DATE(starts_at) = ?", params[:date]) if params[:date].present?
  end

  def reserve
    if @class_session.reservations.exists?(user: current_user)
      redirect_to class_sessions_path, alert: "Ya estás inscrito en esta clase."
    elsif @class_session.reservations.count >= @class_session.max_participants
      redirect_to class_sessions_path, alert: "Clase llena."
    else
      @class_session.reservations.create!(
        user: current_user,
        status: "booked",
        booked_at: Time.zone.now
      )
      redirect_to class_sessions_path, notice: "Reserva exitosa."
    end
  end

  def cancel
    reservation = @class_session.reservations.find_by(user: current_user)
    if reservation
      reservation.destroy
      redirect_to class_sessions_path, notice: "Cancelaste tu inscripción."
    else
      redirect_to class_sessions_path, alert: "No tienes una inscripción para cancelar."
    end
  end

  # GET /class_sessions/1 or /class_sessions/1.json
  def show
  end

  # GET /class_sessions/new
  def new
    @class_session = ClassSession.new
  end

  # GET /class_sessions/1/edit
  def edit
  end

  # POST /class_sessions or /class_sessions.json
  def create
    @class_session = ClassSession.new(class_session_params)

    respond_to do |format|
      if @class_session.save
        format.html { redirect_to @class_session, notice: "Class session was successfully created." }
        format.json { render :show, status: :created, location: @class_session }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @class_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /class_sessions/1 or /class_sessions/1.json
  def update
    respond_to do |format|
      if @class_session.update(class_session_params)
        format.html { redirect_to @class_session, notice: "Class session was successfully updated." }
        format.json { render :show, status: :ok, location: @class_session }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @class_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /class_sessions/1 or /class_sessions/1.json
  def destroy
    @class_session.destroy!

    respond_to do |format|
      format.html { redirect_to class_sessions_path, status: :see_other, notice: "Class session was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_class_session
      @class_session = ClassSession.find(params.expect(:id))
    end
    def authorize_ceo!
      unless current_user&.ceo?
        redirect_to authenticated_root_path, alert: "Acceso denegado"
      end    
    end
    # Only allow a list of trusted parameters through.
    def class_session_params
      params.expect(class_session: [ :class_schedule_id, :activity_id, :room_id, :trainer_id, :starts_at, :ends_at, :max_participants ])
    end
end
