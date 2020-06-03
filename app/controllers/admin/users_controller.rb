class Admin::UsersController < Admin::BaseController

  def index
    @users = User.all
  end 

  def show
    @user = User.find(params[:id])
    @orders = Order.all
  end
  
end