class SessionsController < ApplicationController
  def new
    if session[:user_id]
      flash[:notice] = "You are already logged in"
      redirect_user
    else 
      redirect_user
    end 
  end

  def create
    user = User.find_by(email: params[:email])
    authenticate(user)
  end

  def destroy
    session.delete(:user_id)
    session[:cart] = {} # should the session remember the cart when user logs back in?
    flash[:notice] = "You have logged out"
    redirect_to '/'
  end

  private

  def authenticate(user)
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome #{user.name}"
      redirect_user
    else
      flash[:error] = "Incorrect username or password"
      redirect_to '/login'
    end
  end

  def redirect_user
    return if session[:user_id].nil?
    user = User.find(session[:user_id])
    redirect_to ("/profile") if user.role == "regular"
    redirect_to ("/merchant/dashboard") if user.role == "merchant"
    redirect_to ("/admin/dashboard") if user.role == "admin"
  end
end
