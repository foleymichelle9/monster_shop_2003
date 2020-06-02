class Merchant::DashboardController < Merchant::BaseController
  
  def show
    @user = current_user

    @merchant_orders = Order.pending_merchant_orders(@user.merchant.id)
  end 
end
