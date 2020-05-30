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

    @order1 = create(:order, name: "BOB", user: @regular2)      
    @order2 = create(:order, name: "ANN", user: @regular2) 

    @item_order100 = ItemOrder.create(order: @order1, item: @item100, price: 1, quantity: 100, status: 1)
    @item_order110 = ItemOrder.create(order: @order1, item: @item110, price: 11, quantity: 110, status: 0)
    @item_order111 = ItemOrder.create(order: @order1, item: @item111, price: 111, quantity: 111, status: 1)
    ItemOrder.create(order: @order2, item: @item200, price: 2, quantity: 200)
    ItemOrder.create(order: @order2, item: @item220, price: 22, quantity: 220)
    ItemOrder.create(order: @order2, item: @item222, price: 222, quantity: 222)
    
  end

  describe "US29" do
    it "order show page has details" do
      visit profile_orders_path
      expect(current_path).to eq('/profile/orders') 

      within("#order-#{@order1.id}")do
        click_link("#{@order1.id}")
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

  describe "US30"do
    it "user cancels an order and items are unfulfilled and returned to their inventory" do
      visit "/profile/orders/#{@order1.id}"

      within("#order-#{@order1.id}")do
        expect(page).to have_content("Order Status: pending")
      end
      within("#item-#{@item_order100.item_id}")do
        expect(page).to have_content("Status: fulfilled")
      end
      within("#item-#{@item_order110.item_id}")do
        expect(page).to have_content("Status: unfulfilled")
      end
      within("#item-#{@item_order111.item_id}")do
        expect(page).to have_content("Status: fulfilled")
      end

      within("#cancel-order")do
        click_link "Cancel Order"
      end
      expect(current_path).to eq("/profile/orders/#{@order1.id}")

      within("#order-#{@order1.id}")do
        expect(page).to have_content("Order Status: cancelled")
      end
      within("#item-#{@item_order100.item_id}")do
        expect(page).to have_content("Status: unfulfilled")
      end
      within("#item-#{@item_order110.item_id}")do
        expect(page).to have_content("Status: unfulfilled")
      end
      within("#item-#{@item_order111.item_id}")do
        expect(page).to have_content("Status: unfulfilled")
      end





    end
    
  end
end


# User Story 30, User cancels an order

# As a registered user
# When I visit an order's show page
# I see a button or link to cancel the order
# When I click the cancel button for an order, the following happens:
# - Each row in the "order items" table is given a status of "unfulfilled"
# - The order itself is given a status of "cancelled"
# - Any item quantities in the order that were previously fulfilled have 
    # their quantities returned to their respective merchant's inventory for that item.
# - I am returned to my profile page
# - I see a flash message telling me the order is now cancelled
# - And I see that this order now has an updated status of "cancelled"