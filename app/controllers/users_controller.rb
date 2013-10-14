class UsersController < ApplicationController
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
  end
end
