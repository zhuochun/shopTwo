class UsersController < ApplicationController
  before_action -> { authenticate_role! User::EMPLOYEE, User::MANAGER, User::ADMIN }
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.customers.paginate(page: params[:page], per_page: 50)
  end

  # GET /users/employee
  # GET /users/employee.json
  def employee
    @users = User.employees.paginate(page: params[:page], per_page: 50)
  end

  # GET /users/manager
  # GET /users/manager.json
  def manager
    @users = User.managers.paginate(page: params[:page], per_page: 50)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if current_user.role == User::MANAGER
      @user.update(role: User::EMPLOYEE)
    elsif current_user.role == User::ADMIN
      @user.update(role: User::MANAGER)
    end

    respond_to do |format|
      format.html { redirect_to @user, notice: 'User was successfully promoted.' }
      format.json { head :no_content }
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end
end
