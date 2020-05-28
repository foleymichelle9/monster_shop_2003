require 'rails_helper'

RSpec.describe 'User Login-Logout' do
  before :each do
    @regular2 = create(:user, email: 'regular2@email.com')
    @password = 'p123'
    visit '/login'
    within("#login-form")do
      fill_in :email, with: @regular2.email
      fill_in :password, with: @password
      click_button "Login"
    end
    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant)

    @item100 = create(:item, merchant: @merchant1)
    @item110 = create(:item, merchant: @merchant1)
    @item111 = create(:item, merchant: @merchant1)
    @item200 = create(:item, merchant: @merchant2)
    @item220 = create(:item, merchant: @merchant2)
    @item222 = create(:item, merchant: @merchant2)

    @order1 = create(:order, name: "BOB")      
    @order2 = create(:order, name: "ANN") 

    ItemOrder.create(order: @order1, item: @item100, price: 1, quantity: 100)
    ItemOrder.create(order: @order1, item: @item110, price: 11, quantity: 110)
    ItemOrder.create(order: @order1, item: @item111, price: 111, quantity: 111)
    ItemOrder.create(order: @order2, item: @item200, price: 2, quantity: 200)
    ItemOrder.create(order: @order2, item: @item220, price: 22, quantity: 220)
    ItemOrder.create(order: @order2, item: @item222, price: 222, quantity: 222)
    
  end

  describe "US28" do
    it "user profile dispalys orders and their detials" do
      visit profile_orders_path
      expect(current_path).to eq('/profile/orders') 


      within("#order-#{@order1.id}")do
        expect(page).to have_link(@order1.id)
        expect(page).to_not have_link(@order2.id)
        expect(page).to have_content(@order1.name)
        expect(page).to_not have_content(@order2.name)
        expect(page).to have_content(@order1.created_at)
        expect(page).to have_content(@order1.updated_at)
        expect(page).to have_content(@order1.status)
        expect(page).to have_content("pending")
        expect(page).to have_content(@order1.total_items)
        expect(page).to have_content(@order1.grandtotal)
      end
      within("#order-#{@order2.id}")do
        expect(page).to have_link(@order2.id)
        expect(page).to_not have_link(@order1.id)
        expect(page).to have_content(@order2.name)
        expect(page).to_not have_content(@order1.name)
        expect(page).to have_content(@order2.created_at)
        expect(page).to have_content(@order2.updated_at)
        expect(page).to have_content(@order2.status)
        expect(page).to have_content("pending")
        expect(page).to have_content(@order2.total_items)
        expect(page).to have_content(@order2.grandtotal)
      end


    end
    
  end
  


end