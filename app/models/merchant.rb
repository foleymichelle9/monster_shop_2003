class Merchant <ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :item_orders, through: :items

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip


  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    item_orders.distinct.joins(:order).pluck(:city)
  end
  
  def this_item_orders(params)
    item_orders.where(order_id: params[:id])
  end

  def my_items_this_order(id)
    order = Order.find(id)
    order.items.where(merchant_id:  self.id)
  end

  def my_total_this_order(id)
    my_items_this_order(id).joins(:item_orders).sum('item_orders.quantity * items.price')
  end

end
