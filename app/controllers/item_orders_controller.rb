class ItemOrdersController < ApplicationController

  def update
    item_order = ItemOrder.find(params[:id])
    item_order.update(status: 1)
    update_order(item_order.order)
    flash[:message] = "Item Order #{item_order.id} has been fulfilled"
    redirect_to "/merchant/orders/#{item_order.order.id}"
  end

  private 

  def update_order(order)
    if !order.item_orders.where(status: 0).exists?
      order.update(status: 1)
    end
  end
  

end
