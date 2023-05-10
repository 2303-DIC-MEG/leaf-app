class Admin::UsersController < ApplicationController
  before_action :admin_user

  def index
    @users = User.all.order("created_at DESC")
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user.id)
    else
      render :new
    end
  end

  # def show
  #   @user = User.find(params[:id])
  # end

  private

  def admin_user
    redirect_to (root_path) unless current_user.admin?
  end
end
