class StaffMembersController < ApplicationController
  before_action :set_staff_member, only: %i[ show edit update destroy ]
  before_action :authorize_ceo!
  # GET /staff_members or /staff_members.json
  def index
    @staff_members = StaffMember.all
  end

  # GET /staff_members/1 or /staff_members/1.json
  def show
  end

  # GET /staff_members/new
  def new
    @staff_member = StaffMember.new
    @gym_locations = GymLocation.all
  end

  # GET /staff_members/1/edit
  def edit
    @staff_member = StaffMember.find(params[:id])
    @gym_locations = GymLocation.all
  end

  # POST /staff_members or /staff_members.json
  def create
    @staff_member = StaffMember.new(staff_member_params)

    respond_to do |format|
      if @staff_member.save
        format.html { redirect_to @staff_member, notice: "Staff member was successfully created." }
        format.json { render :show, status: :created, location: @staff_member }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @staff_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /staff_members/1 or /staff_members/1.json
  def update
    respond_to do |format|
      if @staff_member.update(staff_member_params)
        format.html { redirect_to @staff_member, notice: "Staff member was successfully updated." }
        format.json { render :show, status: :ok, location: @staff_member }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @staff_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /staff_members/1 or /staff_members/1.json
  def destroy
    @staff_member.destroy!

    respond_to do |format|
      format.html { redirect_to staff_members_path, status: :see_other, notice: "Staff member was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_staff_member
      @staff_member = StaffMember.find(params.expect(:id))
    end
    def authorize_ceo!
      unless current_user&.ceo?
        redirect_to authenticated_root_path, alert: "Acceso denegado"
      end
    end
    # Only allow a list of trusted parameters through.
    def staff_member_params
      params.expect(staff_member: [ :name, :email, :role, :gym_location_id ])
    end
end
