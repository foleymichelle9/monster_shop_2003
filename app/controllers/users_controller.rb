class UsersController < ApplicationController

  def new

  end

  def create
    @user = User.new(user_params)
    @user.save
    session[:user_id] = @user.id
    flash[:success] = "Welcome #{@user.name}! You are now registered and logged in!"
    redirect_to "/profile"
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end
end 