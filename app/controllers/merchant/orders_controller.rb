class Merchant::OrdersController < Merchant::BaseController
  
  def show
    @order = Order.find(params[:id])
    @merchant_item_orders = current_user.merchant.this_item_orders(params)
  end 
end