require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should belong_to :user}
    it {should have_many :item_orders}
    it {should have_many(:items).through(:item_orders)}
  end

  describe 'instance methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @user = create(:user)
      @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: @user.id)

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    end
    it '#grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end
    it '#total items' do
      expect(@order_1.total_items).to eq(5)
    end
  end
  describe 'class methods' do
    it 'pending_merchant_orders' do

      @merchant1 = create(:merchant)
      @merchant2 = create(:merchant)
      @merchant3 = create(:merchant)
      
      @item1 = create(:item, merchant_id: @merchant1.id)
      @item2 = create(:item, merchant_id: @merchant1.id)
      @item3 = create(:item, merchant_id: @merchant1.id)
      @item4 = create(:item, merchant_id: @merchant1.id)
      @item5 = create(:item, merchant_id: @merchant2.id)
      @item6 = create(:item, merchant_id: @merchant1.id)
      @item7 = create(:item, merchant_id: @merchant3.id)

      @order1 = create(:order, status: "pending")
      @order2 = create(:order, status: "packaged")
      @order3 = create(:order, status: "pending")
      @order4 = create(:order, status: "pending")
      @order5 = create(:order, status: "pending")

      ItemOrder.create!(order: @order1, item: @item1, price: @item1.price, quantity: 1, status: "unfulfilled")
      ItemOrder.create!(order: @order1, item: @item2, price: @item1.price, quantity: 1, status: "unfulfilled")
      ItemOrder.create!(order: @order2, item: @item3, price: @item3.price, quantity: 1, status: "fulfilled")
      ItemOrder.create!(order: @order3, item: @item4, price: @item4.price, quantity: 1, status: "unfulfilled")
      ItemOrder.create!(order: @order3, item: @item1, price: @item1.price, quantity: 1, status: "unfulfilled")
      ItemOrder.create!(order: @order4, item: @item5, price: @item5.price, quantity: 1, status: "unfulfilled")
      ItemOrder.create!(order: @order5, item: @item7, price: @item7.price, quantity: 1, status: "unfulfilled")

      expect(Order.pending_merchant_orders(@merchant1.id)).to eq([@order1, @order3])
    end
  end
end
