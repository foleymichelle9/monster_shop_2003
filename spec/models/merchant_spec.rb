require 'rails_helper'

describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many :items}
    it {should have_many :users}
  end

  describe 'instance methods' do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    end
    it 'no_orders' do
      expect(@meg.no_orders?).to eq(true)
      user = create(:user)
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user.id)
      item_order_1 = order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.no_orders?).to eq(false)
    end

    it 'item_count' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 30, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.item_count).to eq(2)
    end

    it 'average_item_price' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.average_item_price).to eq(70)
    end

    it 'distinct_cities' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      user = create(:user)
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user.id)
      order_2 = Order.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17033, user_id: user.id)
      order_3 = Order.create!(name: 'Dao', address: '123 Mike Ave', city: 'Denver', state: 'CO', zip: 17033, user_id: user.id)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order_2.item_orders.create!(item: chain, price: chain.price, quantity: 2)
      order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.distinct_cities).to include("Denver")
      expect(@meg.distinct_cities).to include("Hershey")
    end

    it "#this_order_items" do
      @regular1 = create(:user)
      @regular2 = create(:user)
      @regular3 = create(:user)
      @merchant1 = create(:merchant)
      @merchant2 = create(:merchant)
      @merchant1_user = create(:user, merchant_id: @merchant1.id )
      @merchant2_user = create(:user, merchant_id: @merchant2.id )

      @item1 = create(:item, merchant: @merchant1)
      @item2 = create(:item, merchant: @merchant1)
      @item3 = create(:item, merchant: @merchant2)

      @order10 = create(:order, user: @regular1, status: 3) #cancelled
      @order11 = create(:order, user: @regular1, status: 1) #packaged
      @order2 = create(:order, user: @regular2, status: 2) #shipped
      @order3 = create(:order, user: @regular3, status: 0) #pending

      @item_order101 = ItemOrder.create(order_id: @order10.id, item_id: @item1.id, status: 0, price: @item1.price, quantity: 1)
      @item_order102 = ItemOrder.create(order_id: @order10.id, item_id: @item2.id, status: 0, price: @item2.price, quantity: 1)
      ItemOrder.create(order_id: @order11.id, item_id: @item2.id, status: 1, price: @item2.price, quantity: 1)
      ItemOrder.create(order_id: @order2.id, item_id: @item2.id, status: 1, price: @item2.price, quantity: 2)
      ItemOrder.create(order_id: @order3.id, item_id: @item3.id, status: 1, price: @item3.price, quantity: 3)

      params = {:id => @order10.id}
      expect(@merchant1.this_item_orders(params)).to eq([@item_order101, @item_order102])
    end

  end
end
