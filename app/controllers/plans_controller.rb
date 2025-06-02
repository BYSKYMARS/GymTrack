class PlansController < ApplicationController
  before_action :authenticate_user!
  before_action :set_plan, only: [:show, :subscribe]
  
  # GET /plans or /plans.json
  def index
    @plans = Plan.all
  end

  # GET /plans/1 or /plans/1.json
  def show
  end

  # GET /plans/new
  def new
    @plan = Plan.new
  end

  # GET /plans/1/edit
  def edit
  end

  # POST /plans or /plans.json
  def create
    @plan = Plan.new(plan_params)

    respond_to do |format|
      if @plan.save
        format.html { redirect_to @plan, notice: "Plan was successfully created." }
        format.json { render :show, status: :created, location: @plan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plans/1 or /plans/1.json
  def update
    respond_to do |format|
      if @plan.update(plan_params)
        format.html { redirect_to @plan, notice: "Plan was successfully updated." }
        format.json { render :show, status: :ok, location: @plan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plans/1 or /plans/1.json
  def destroy
    @plan.destroy!

    respond_to do |format|
      format.html { redirect_to plans_path, status: :see_other, notice: "Plan was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def subscribe
    if current_user.active_plan?
      redirect_to plans_path, alert: "Ya tienes un plan activo."
      return
    end
  
    payment = current_user.payments.create!(
      plan: @plan,
      amount_paid: @plan.price,
      paid_on: Date.today,
      expires_on: Date.today + @plan.duration.days,
      status: "active"
    )
  
    redirect_to users_dashboard_path, notice: "Plan activado correctamente: #{@plan.name}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plan
      @plan = Plan.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def plan_params
      params.expect(plan: [ :name, :price, :duration, :description ])
    end
end
