class UsersController < ApplicationController

  def new

  end

  def edit
    @user = User.find(params[:user_id])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome #{@user.name}! You are now registered and logged in!"
      redirect_to "/profile"
    elsif email_exists?
      flash[:error] = "Email has already been taken"
      render :new
    elsif @user.password != @user.password_confirmation
      flash[:error] = "Passwords did not match."
      render :new
    else
      flash[:notice] = "#{missing_params(user_params).join(", ")} can't be blank, please try again."
      render :new
    end
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end

  def email_exists?
    User.where(email: params[:email]).exists?
  end

  def missing_params(user_params)
    missing_params = []
    user_params.each do |key, value|
      if value == ""
        missing_params << "#{key}"
      end
    end
    missing_params
  end
end 