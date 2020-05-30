class Merchant::DashboardController < Merchant::BaseController
  
  def show
    @user = current_user
  end 
end