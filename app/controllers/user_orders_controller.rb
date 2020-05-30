class UserOrdersController < ApplicationController

  def index
    @user = current_user
  end

  def show
    @order = Order.find(params[:id])
  end

  def update 
    order = Order.find(params[:id])
    case params[:type]
    when "cancel"
      order.update(status: 3)
      order.item_orders.each { |item_order| item_order.update(status: 0) } 
    end
    redirect_back(fallback_location: "/profile/orders/#{order.id}")
  end
  

end