class GymLocationsController < ApplicationController
  before_action :set_gym_location, only: %i[ show edit update destroy ]

  # GET /gym_locations or /gym_locations.json
  def index
    @gym_locations = GymLocation.all
  end

  # GET /gym_locations/1 or /gym_locations/1.json
  def show
  end

  # GET /gym_locations/new
  def new
    @gym_location = GymLocation.new
    @cities = City.all
  end

  # GET /gym_locations/1/edit
  def edit
    @cities = City.all
  end

  # POST /gym_locations or /gym_locations.json
  def create
    @gym_location = GymLocation.new(gym_location_params)

    respond_to do |format|
      if @gym_location.save
        format.html { redirect_to @gym_location, notice: "Gym location was successfully created." }
        format.json { render :show, status: :created, location: @gym_location }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @gym_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gym_locations/1 or /gym_locations/1.json
  def update
    respond_to do |format|
      if @gym_location.update(gym_location_params)
        format.html { redirect_to @gym_location, notice: "Gym location was successfully updated." }
        format.json { render :show, status: :ok, location: @gym_location }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @gym_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gym_locations/1 or /gym_locations/1.json
  def destroy
    @gym_location.destroy!

    respond_to do |format|
      format.html { redirect_to gym_locations_path, status: :see_other, notice: "Gym location was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gym_location
      @gym_location = GymLocation.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def gym_location_params
      params.expect(gym_location: [ :name, :address, :city_id ])
    end
end
