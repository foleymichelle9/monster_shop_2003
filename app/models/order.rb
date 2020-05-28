class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  has_many :item_orders
  has_many :items, through: :item_orders

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def item_quantity
    items.sum(:quantity)
  end
  

  enum status: {pending: 0, packaged: 1, shipped: 2, cancelled: 3}
end
