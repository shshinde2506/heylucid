class RealityChecksController < ApplicationController
  # this set reality check method gets called before teh actions specified in the array 
  before_action :set_reality_check, only: [:show, :edit, :update, :destroy]

  def index
    @reality_checks =
    if user.admin
      RealityCheck.all
    else
      RealityCheck.where(user_id: current_user.id)
    end
  end


  def show
    # set reality check does the first line and rails implicity does the second
    
    # @user = User.find_by(user_params)
    # render 'show'
  end

  # GET /reality_checks/new
  def new
    @reality_check = RealityCheck.new
  end

  # GET /reality_checks/1/edit
  def edit
    redirect_back unless admin, notice: 'You Cant Change The Past!!'
  end

  # POST /reality_checks
  # POST /reality_checks.json
  def create
    @reality_check = RealityCheck.new(reality_check_params)

    respond_to do |format|
      if @reality_check.save
        format.html { redirect_to @reality_check, notice: 'Reality check was successfully created.' }
        format.json { render :show, status: :created, location: @reality_check }
      else
        format.html { render :new }
        format.json { render json: @reality_check.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reality_checks/1
  # PATCH/PUT /reality_checks/1.json
  def update
    respond_to do |format|
      if @reality_check.update(reality_check_params)
        format.html { redirect_to @reality_check, notice: 'Reality check was successfully updated.' }
        format.json { render :show, status: :ok, location: @reality_check }
      else
        format.html { render :edit }
        format.json { render json: @reality_check.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reality_checks/1
  # DELETE /reality_checks/1.json
  def destroy
    if admin
    @reality_check.destroy
    respond_to do |format|
      format.html { redirect_to reality_checks_url, notice: 'Reality check was successfully destroyed.' }
      format.json { head :no_content }
    end
    else
      redirect_to dashboard, notice: "You Can't Undo The Past!!"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reality_check
      @reality_check = RealityCheck.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reality_check_params
      params.fetch(:reality_check, {:user_id})
    end
end
