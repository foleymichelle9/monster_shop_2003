class OrdersController < BaseController
  before_action :require_regular, except: [:new, :create, :update]
  before_action :require_admin, only: [:update]

  def index
    @orders = Order.all
  end
  

  def new

  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    order = Order.create(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      reduce_merchant_inventory(order)
      session.delete(:cart)
      redirect_to "/orders/#{order.id}"
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def update 
    if params[:admin] == "true"
      order = Order.find(params[:id])
      order.update(status: 2)
      flash[:notice] = "Order #{order.id} has been shipped"
      redirect_to '/admin/dashboard'
    end
  end
  


  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip, :user_id)
  end

  def reduce_merchant_inventory(order)
    order.item_orders.each do |item_order|
      new_inventory = item_order.item.inventory-item_order.quantity
      item_order.item.update(inventory: new_inventory) 
    end
  end
  
end

