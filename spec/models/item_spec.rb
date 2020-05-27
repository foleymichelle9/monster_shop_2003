require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
    it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      order = Order.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end

    it 'active_items' do
      item1 = create(:item)
      item2 = create(:item, active?: false)
      item3 = create(:item)

      items = Item.all

      expect(items.active_items).to eq([@chain, item1, item3])
    end
  end 
  describe "methods" do
    it 'most_popular_items' do
      item1 = create(:item, name: "item1")
      item2 = create(:item, name: "item2", active?: false)
      item3 = create(:item, name: "item3")
      item4 = create(:item, name: "item4")
      item5 = create(:item, name: "item5")
      item6 = create(:item, name: "item6")
      item7 = create(:item, name: "item7")
      item8 = create(:item, name: "item8")

      order1 = create(:order)      
      order2 = create(:order)      
      order3 = create(:order)      
      order4 = create(:order)      
      order5 = create(:order)       

      ItemOrder.create(order: order1, item: item1, price: 5, quantity: 20)
      ItemOrder.create(order: order1, item: item4, price: 5, quantity: 15)
      ItemOrder.create(order: order2, item: item1, price: 5, quantity: 2)
      ItemOrder.create(order: order2, item: item3, price: 5, quantity: 6)
      ItemOrder.create(order: order3, item: item3, price: 5, quantity: 6)
      ItemOrder.create(order: order4, item: item6, price: 5, quantity: 6)
      ItemOrder.create(order: order4, item: item6, price: 5, quantity: 1)
      ItemOrder.create(order: order4, item: item7, price: 5, quantity: 5)
      ItemOrder.create(order: order5, item: item8, price: 5, quantity: 3)

      items = Item.all
      
      expect(items.popular_items(5, 'desc')).to eq([item1, item4, item3, item6, item7])
      expect(items.popular_items(5, 'asc')).to eq([item8, item7, item6, item3, item4])
    end
  end
end
