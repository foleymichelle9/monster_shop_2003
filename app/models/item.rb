class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0


  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def self.active_items
    Item.where(active?: true)
  end

  def self.popular_items(limit, order)
    Item.select("items.*, sum(item_orders.quantity)")
        .joins(:item_orders)
        .group('items.id')
        .order("sum(item_orders.quantity) #{order}")
        .limit(limit)
  end 

  def quantity_purchased
    item_orders.sum(:quantity)
  end
end
