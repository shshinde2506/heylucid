class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :dashboard, :update, :initial_check, :destroy]
  after_action :initial_check, only: [:create]

  def dashboard
    @reality_checks = current_user.reality_checks
  end

  def current_day
    @today = Date.today
  end

  def index
    if current_user.admin
      @users = User.all
    else
      redirect_to root_path
      flash[:notice] = 'Restricted Access'
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if logged_in?
      if @user.id == current_user.id
        render 'dashboard'
      end
    else
      redirect_to login_path
      flash[:error] = "Access Denied"
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.find_or_initialize_by(user_params)
    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if @user.admin || @user == current_user
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
      end
      session.destroy
    else
      redirect_to user_path(@user), notice: 'NOPE'
    end
  end

  def initial_check
    # fix me
    RealityCheck.create(user_id: @user.id)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    if params[:id]
      @user = User.find(params[:id])
    else
      @user == nil
    end
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
