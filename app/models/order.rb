class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  belongs_to :user
  has_many :item_orders
  has_many :items, through: :item_orders
  enum status: {pending: 0, packaged: 1, shipped: 2, cancelled: 3}

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_items
    items.sum(:quantity)
  end

  def self.pending_merchant_orders(merchant_id)
    Order.joins(:item_orders => :item)
         .distinct
         .where("items.merchant_id = '#{merchant_id}' AND orders.status = '0'")
  end 
end
