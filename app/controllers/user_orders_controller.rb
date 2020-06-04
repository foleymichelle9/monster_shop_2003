class UserOrdersController < BaseController
  before_action :require_regular, except: [:new, :create]

  def index
    @user = current_user
  end

  def show
    @order = Order.find(params[:id])
  end

  def update 
    order = Order.find(params[:id])
    order.update(status: 3)
    order.item_orders.each { |item_order| item_order.update(status: 0) } 
    return_merchant_inventory(order)
    flash[:notice] = "Order #{order.id} has been cancelled"
    redirect_to  "/profile"
  end
  
  private 

  def return_merchant_inventory(order)
    order.item_orders.each do |item_order|
      new_inventory = item_order.item.inventory+item_order.quantity
      item_order.item.update(inventory: new_inventory) 
    end
  end



end