class Merchant::DashboardController < Merchant::BaseController
  
  def show
    @user = current_user

    if @user.merchant
      @merchant_orders = Order.pending_merchant_orders(@user.merchant.id) 
    else
      @merchant_orders = []
    end
    
  end 
end
