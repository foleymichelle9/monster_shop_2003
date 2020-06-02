require 'rails_helper'

RSpec.describe 'merchant dashboard show page', type: :feature do
  describe 'As a merchant' do
    before(:each) do

      @merchant1 = create(:merchant)
      @user1 = create(:user, role: "merchant", merchant_id: @merchant1.id)

      @merchant2 = create(:merchant)
      @user2 = create(:user, role: "merchant")

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
      
      visit merchant_dashboard_path
    end
    it 'I can see the name and full address of the merchant I work for' do

      expect(page).to have_content(@merchant1.name)
      expect(page).to have_content(@merchant1.address)
      expect(page).to have_content(@merchant1.city)
      expect(page).to have_content(@merchant1.state)
      expect(page).to have_content(@merchant1.zip)
      expect(page).to_not have_content(@merchant2.name)
    end
    it 'There is a link to my merchants item index page' do

      click_link "Items for #{@merchant1.name}"

      expect(current_path).to eq(merchant_items_path)
    end
  end
  describe 'As an admin' do
    before(:each) do
      
      @user2 = create(:user, role: "admin")
      
      @merchant1 = create(:merchant)
      @merchant2 = create(:merchant)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user2)
      
      visit merchants_path
    end
    it 'I visit the merchants index page, I can click on a merchant name and see everything the merchant would see ' do

      click_link @merchant1.name 

      expect(current_path).to eq(admin_merchant_path(@merchant1))

      expect(page).to have_content(@merchant1.name)
      expect(page).to have_content(@merchant1.address)
      expect(page).to have_content(@merchant1.city)
      expect(page).to have_content(@merchant1.state)
      expect(page).to have_content(@merchant1.zip)
      expect(page).to_not have_content(@merchant2.name)
    end
  end
end
RSpec.describe 'merchant dashboard show page', type: :feature do
  describe 'US-35 As a merchant' do
    before(:each) do

      @merchant1 = create(:merchant)
      @user1 = create(:user, role: "merchant", merchant_id: @merchant1.id)

      @item1 = create(:item, merchant_id: @merchant1.id)
      @item2 = create(:item, merchant_id: @merchant1.id)
      @item3 = create(:item, merchant_id: @merchant1.id)
      @item4 = create(:item, merchant_id: @merchant1.id)
      @item5 = create(:item)
      @item6 = create(:item, merchant_id: @merchant1.id)

      @order1 = create(:order, status: "pending")
      @order2 = create(:order, status: "packaged")
      @order3 = create(:order, status: "pending")
      @order4 = create(:order, status: "pending")

      ItemOrder.create!(order: @order1, item: @item1, price: @item1.price, quantity: 1, status: "unfulfilled")
      ItemOrder.create!(order: @order1, item: @item2, price: @item2.price, quantity: 1, status: "unfulfilled")
      ItemOrder.create!(order: @order2, item: @item3, price: @item3.price, quantity: 1, status: "fulfilled")
      ItemOrder.create!(order: @order3, item: @item4, price: @item4.price, quantity: 1, status: "unfulfilled")
      ItemOrder.create!(order: @order3, item: @item1, price: @item1.price, quantity: 1, status: "unfulfilled")
      ItemOrder.create!(order: @order4, item: @item5, price: @item5.price, quantity: 1, status: "unfulfilled")

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
      
      visit merchant_dashboard_path
    end
    it 'All pending orders with items I sell are listed' do

      within("#order-#{@order1.id}") do
        expect(page).to have_link("#{@order1.id}", :href=> "/merchant/orders/#{@order1.id}")
        expect(page).to have_content(@order1.created_at)
        expect(page).to have_content(@order1.total_items)
        expect(page).to have_content(@order1.grandtotal)
      end
      within("#order-#{@order3.id}") do
        expect(page).to have_link("#{@order3.id}", :href=> "/merchant/orders/#{@order3.id}")
        expect(page).to have_content(@order3.created_at)
        expect(page).to have_content(@order3.total_items)
        expect(page).to have_content(@order3.grandtotal)
      end
    end
  end 
end 
