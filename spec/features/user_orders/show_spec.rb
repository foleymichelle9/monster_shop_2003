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

    @item100 = create(:item, merchant: @merchant1, price: 1, inventory: 100)
    @item110 = create(:item, merchant: @merchant1, price: 11, inventory: 100)
    @item111 = create(:item, merchant: @merchant1, price: 111, inventory: 100)
    @item200 = create(:item, merchant: @merchant2, price: 2)
    @item220 = create(:item, merchant: @merchant2, price: 22)
    @item222 = create(:item, merchant: @merchant2, price: 222)

    @order1 = create(:order, name: "BOB", user: @regular2)      
    @order2 = create(:order, name: "ANN", user: @regular2) 

    @item_order100 = ItemOrder.create(order: @order1, item: @item100, price: @item100.price, quantity: 11, status: 1)
    @item_order110 = ItemOrder.create(order: @order1, item: @item110, price: @item110.price, quantity: 12, status: 0)
    @item_order111 = ItemOrder.create(order: @order1, item: @item111, price: @item111.price, quantity: 13, status: 1)
    ItemOrder.create(order: @order2, item: @item200, price: @item200.price, quantity: 21)
    ItemOrder.create(order: @order2, item: @item220, price: @item220.price, quantity: 22)
    ItemOrder.create(order: @order2, item: @item222, price: @item222.price, quantity: 23)
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
        expect(page).to have_css("img[src*='#{@item_order100.item.image}']")
        expect(page).to_not have_css("img[src*='#{@item_order110.item.image}']")
        expect(page).to have_content(@item100.name)
        expect(page).to_not have_content(@item110.name)
        expect(page).to have_content(@item100.description)
        expect(page).to_not have_content(@item110.description)
        expect(page).to have_content(@item_order100.quantity)
        expect(page).to have_content(@item100.price)
        expect(page).to have_content(@item_order100.subtotal)
        expect(page).to_not have_content(@item_order110.subtotal)
      end

      within("#item-#{@item_order110.item_id}")do
        expect(page).to have_css("img[src*='#{@item_order110.item.image}']")
        expect(page).to have_content(@item110.name)
        expect(page).to have_content(@item110.description)
        expect(page).to have_content(@item_order110.quantity)
        expect(page).to have_content(@item110.price)
        expect(page).to have_content("$132.00")
      end

      within("#item-#{@item_order111.item_id}")do
        expect(page).to have_css("img[src*='#{@item_order111.item.image}']")
        expect(page).to have_content(@item111.name)
        expect(page).to have_content(@item111.description)
        expect(page).to have_content(@item_order111.quantity)
        expect(page).to have_content(@item111.price)
        expect(page).to have_content("$1,443.00")
      end

      within("#grandtotal")do
        expect(page).to have_content("Total: $1,586.00")
      end
      within("#total_items")do
        expect(page).to have_content(@order1.total_items)
      end

    end  
  end

  describe "US30"do
    it "user cancels an order and items are unfulfilled and returned to their inventory" do
      visit '/items'
      within("#item-#{@item100.id}")do
        expect(page).to have_content("Inventory: 100")
      end
      within("#item-#{@item110.id}")do
        expect(page).to have_content("Inventory: 100")
      end
      within("#item-#{@item111.id}")do
        expect(page).to have_content("Inventory: 100")
      end

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
      expect(current_path).to eq("/profile")
      expect(page).to have_content("Order #{@order1.id} has been cancelled")

      visit '/items'
      within("#item-#{@item100.id}")do
        expect(page).to have_content("Inventory: 111")
      end
      within("#item-#{@item110.id}")do
        expect(page).to have_content("Inventory: 112")
      end
      within("#item-#{@item111.id}")do
        expect(page).to have_content("Inventory: 113")
      end

      visit "/profile/orders/#{@order1.id}"
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
