class CartController < BaseController
  before_action :require_non_admin

  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s) unless cart.inventory_reached?(params[:item_id])
    if cart.inventory_reached?(params[:item_id])
      flash[:error] = "You have reached the inventory limit. You cannot add #{item.name} to your cart."
    else
      flash[:success] = "#{item.name} was successfully added to your cart"
    end 
    
    redirect_to "/items" if params[:cart].nil?
    redirect_to "/cart" if params[:cart]
  end

  def show
    @items = cart.items
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def decrement
    if !cart.quantity_one?(params[:item_id])
      cart.remove_item(params[:item_id])
      redirect_to "/cart"
    elsif cart.quantity_one?(params[:item_id])
      remove_item
    end
  end
end
