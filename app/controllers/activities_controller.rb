class ActivitiesController < ApplicationController
  before_action :set_activity, only: %i[ show edit update destroy ]
  before_action :authorize_ceo!
  # GET /activities or /activities.json
  def index
    @activities = Activity.all
    @activities = @activities.where("name ILIKE ?", "%#{params[:name]}%") if params[:name].present?
    @activities = @activities.where("category ILIKE ?", "%#{params[:category]}%") if params[:category].present?
  end
  

  # GET /activities/1 or /activities/1.json
  def show
  end

  # GET /activities/new
  def new
    @activity = Activity.new
  end

  # GET /activities/1/edit
  def edit
  end

  # POST /activities or /activities.json
  def create
    @activity = Activity.new(activity_params)

    respond_to do |format|
      if @activity.save
        format.html { redirect_to @activity, notice: "Activity was successfully created." }
        format.json { render :show, status: :created, location: @activity }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activities/1 or /activities/1.json
  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to @activity, notice: "Activity was successfully updated." }
        format.json { render :show, status: :ok, location: @activity }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1 or /activities/1.json
  def destroy
    @activity.destroy!

    respond_to do |format|
      format.html { redirect_to activities_path, status: :see_other, notice: "Activity was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.find(params.expect(:id))
    end
    def authorize_ceo!
      unless current_user&.ceo?
        redirect_to authenticated_root_path, alert: "Acceso denegado"
      end
    end
    # Only allow a list of trusted parameters through.
    def activity_params
      params.expect(activity: [ :name, :category ])
    end
end
