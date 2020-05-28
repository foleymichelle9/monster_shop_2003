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

    @item100 = create(:item, merchant: @merchant1, price: 1)
    @item110 = create(:item, merchant: @merchant1, price: 11)
    @item111 = create(:item, merchant: @merchant1, price: 111)
    @item200 = create(:item, merchant: @merchant2)
    @item220 = create(:item, merchant: @merchant2)
    @item222 = create(:item, merchant: @merchant2)

    @order1 = create(:order, name: "BOB")      
    @order2 = create(:order, name: "ANN") 

    @item_order100 = ItemOrder.create(order: @order1, item: @item100, price: 1, quantity: 100)
    @item_order110 = ItemOrder.create(order: @order1, item: @item110, price: 11, quantity: 110)
    @item_order111 = ItemOrder.create(order: @order1, item: @item111, price: 111, quantity: 111)
    ItemOrder.create(order: @order2, item: @item200, price: 2, quantity: 200)
    ItemOrder.create(order: @order2, item: @item220, price: 22, quantity: 220)
    ItemOrder.create(order: @order2, item: @item222, price: 222, quantity: 222)
    
  end

  describe "US29" do
    it "order show page has details" do
      visit profile_orders_path
      expect(current_path).to eq('/profile/orders') 

      within("#order-#{@order1.id}")do
        click_link(@order1.id)
      end

      expect(current_path).to eq("/profile/orders/#{@order1.id}")

      within("#order-#{@order1.id}")do
        expect(page).to have_content("Order id: #{@order1.id}")
        expect(page).to_not have_content("Order id: #{@order2.id}")
        expect(page).to have_content("Order Status: #{@order1.status}")
        expect(page).to have_content("Order Status: pending")
      end

      within("#datecreated")do
        expect(page).to have_content(@order1.created_at)
      end
      within("#dateupdated")do
        expect(page).to have_content(@order1.created_at)
      end

      within("#item-#{@item_order100.item_id}")do
        expect(page).to have_css(".item-#{@item_order100.item_id}-image")
        expect(page).to_not have_css(".item-#{@item_order110.item_id}-image")
        expect(page).to have_content(@item100.name)
        expect(page).to_not have_content(@item110.name)
        expect(page).to have_content(@item100.description)
        expect(page).to_not have_content(@item110.description)
        expect(page).to have_content(@item_order100.quantity)
        expect(page).to_not have_content(@item_order110.quantity)
        expect(page).to have_content(@item100.price)
        expect(page).to_not have_content(@item110.price)
        expect(page).to have_content(@item_order100.subtotal)
        expect(page).to_not have_content(@item_order110.subtotal)
      end

      within("#item-#{@item_order110.item_id}")do
        expect(page).to have_css(".item-#{@item_order110.item_id}-image")
        expect(page).to have_content(@item110.name)
        expect(page).to have_content(@item110.description)
        expect(page).to have_content(@item_order110.quantity)
        expect(page).to have_content(@item110.price)
        expect(page).to have_content("$1,210.00")
      end

      within("#item-#{@item_order111.item_id}")do
        expect(page).to have_css(".item-#{@item_order111.item_id}-image")
        expect(page).to have_content(@item111.name)
        expect(page).to have_content(@item111.description)
        expect(page).to have_content(@item_order111.quantity)
        expect(page).to have_content(@item111.price)
        expect(page).to have_content("$12,321.00")
      end

      within("#grandtotal")do
        expect(page).to have_content("Total: $13,631.00")
      end
      within("#total_items")do
        expect(page).to have_content(@order1.total_items)
      end

    end  
  end
end

# x As a registered user
# x When I visit my Profile Orders page
# x And I click on a link for order's show page
# x My URL route is now something like "/profile/orders/15"
# x I see all information about the order, including the following information:
# x - the ID of the order
# x - the date the order was made
# x - the date the order was last updated
# x - the current status of the order
# - each item I ordered,
  # x - including name, 
  # x - description, 
  # x - thumbnail, 
  # x - quantity, 
  # x - price and 
  # x - subtotal
# x - the total quantity of items in the whole order
# x - the grand total of all items for that order
