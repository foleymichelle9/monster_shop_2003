require 'rails_helper'

RSpec.describe 'Merchant order show page' do
  before :each do
    # log in as user, add items from 2 merchants to cart,
    # create order, login as merchant
    @regular1 = create(:user, email: 'regular2@email.com')
    @password = 'p123'
    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant)
    @merchant1_user = create(:user, merchant_id: @merchant1.id, role: 1 )
    @merchant2_user = create(:user, merchant_id: @merchant2.id, role: 1 )
    @item1 = create(:item, merchant: @merchant1, price: 50, inventory: 50)
    @item2 = create(:item, merchant: @merchant1, price: 10, inventory: 50)
    @item3 = create(:item, merchant: @merchant2, inventory: 50)
  
    visit '/login'
    within("#login-form")do
      fill_in :email, with: @regular1.email
      fill_in :password, with: @password
      click_button "Login"
    end

    visit "/items/#{@item1.id}"
    click_on "Add To Cart"
    visit "/items/#{@item1.id}"
    click_on "Add To Cart"
    visit "/items/#{@item2.id}"
    click_on "Add To Cart"
    visit "/items/#{@item3.id}"
    click_on "Add To Cart"

    visit "/cart"
    click_link "Checkout"
    fill_in "name",	with: @regular1.name 
    fill_in "address",	with: @regular1.address 
    fill_in "city",	with: @regular1.city 
    fill_in "state",	with: @regular1.state 
    fill_in "zip",	with: @regular1.zip 
    click_button "Create Order"

    @order1 = Order.last
    click_on "Logout"

    visit '/login'
    within("#login-form")do
      fill_in :email, with: @merchant1_user.email
      fill_in :password, with: @password
      click_button "Login"
    end

    expect(current_path).to eq('/merchant/dashboard')
  end
  
  it "US31 part I - merchant can fulfill orders" do
    visit "/merchant/orders/#{@order1.id}"
    
    within("#item-#{@item1.id}")do
      expect(page).to have_content(@item1.name)
      expect(page).to have_content("Item Order Status: unfulfilled")
      expect(page).to_not have_content(@item2.name)
      expect(page).to have_button("Fulfill Item")
    end
    within("#item-#{@item2.id}")do
      expect(page).to have_content(@item2.name)
      expect(page).to have_content("Item Order Status: unfulfilled")
      expect(page).to_not have_content(@item3.name)
      click_button("Fulfill Item")
    end
    within("#item-#{@item1.id}")do
      expect(page).to have_content("Item Order Status: unfulfilled")
    end
    within("#item-#{@item2.id}")do
      expect(page).to have_content("Item Order Status: fulfilled")
    end
    
  end

  it "US31 part II - when all merchants fulfill items, order status is fulfilled" do
    visit "/merchant/orders/#{@order1.id}"

    within("#order-#{@order1.id}")do
      expect(page).to have_content("Order Status: pending")
    end
    within("#item-#{@item1.id}")do
      click_button("Fulfill Item")
    end
    expect(page).to have_content("has been fulfilled")
    within("#item-#{@item2.id}")do
      click_button("Fulfill Item")
    end
    click_link "Logout"

    visit '/login'
    within("#login-form")do
      fill_in :email, with: @merchant2_user.email
      fill_in :password, with: @password
      click_button "Login"
    end

    visit "/merchant/orders/#{@order1.id}"

    within("#order-#{@order1.id}")do
      expect(page).to have_content("Order Status: pending")
    end
    within("#item-#{@item3.id}")do
      click_button("Fulfill Item")
    end

    within("#order-#{@order1.id}")do
      expect(page).to have_content("Order Status: packaged")
    end
  end
  it "US49 part I - I see the recepients name and address for order" do
    visit "/merchant/orders/#{@order1.id}"

    within("#order-#{@order1.id}")do
      expect(page).to have_content(@order1.user.name)
      expect(page).to have_content(@order1.user.full_address)
    end
  end
  it "US49 part II - I see name, image, price, and quantity for each item" do
    visit "/merchant/orders/#{@order1.id}"

    within("#item-#{@item1.id}")do
      expect(page).to have_content(@item1.name)
      expect(page).to have_xpath("//img[@src = '#{@item1.image}' and @alt= '#{@item1.id}']")
      expect(page).to have_content("$50.00")
      expect(page).to have_content(@item1.item_orders.first.quantity)
    end
    within("#item-#{@item2.id}")do
      expect(page).to have_content(@item2.name)
      expect(page).to have_xpath("//img[@src = '#{@item2.image}' and @alt= '#{@item2.id}']")
      expect(page).to have_content("$10.00")
      expect(page).to have_content(@item2.item_orders.first.quantity)
    end
  end
end
RSpec.describe 'Merchant order show page' do
  before :each do
    @regular_user = create(:user)

    @merchant1 = create(:merchant)
    @merchant_user = create(:user, merchant_id: @merchant1.id, role: 1 )

    @item1 = create(:item, merchant: @merchant1, price: 50, inventory: 2)
    @item2 = create(:item, merchant: @merchant1, price: 10, inventory: 5)

    @order1 = create(:order, user_id: @regular_user.id)    
    @order2 = create(:order, user_id: @regular_user.id)
    
    @item_order1 = ItemOrder.create(order: @order1, item: @item1, price: @item1.price, quantity: 4)
    @item_order2 = ItemOrder.create(order: @order2, item: @item2, price: @item2.price, quantity: 4)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
  end
  it "US50 part I - Quantity requested is more than item inventory, I do not see a fulfill item button" do
    visit "/merchant/orders/#{@order1.id}"
    
    within("#item-#{@item1.id}")do
      expect(page).to_not have_button("Fulfill Item")
    end

    visit "/merchant/orders/#{@order2.id}"
  
    within("#item-#{@item2.id}")do
      expect(page).to have_button("Fulfill Item")
    end
  end 
  it "US50 part II -Fulfilling an order permanently reduces an item's inventory by desired quantity" do
    visit "/merchant/orders/#{@order2.id}"

    expect(@item2.inventory).to eq(5)

    within("#item-#{@item2.id}")do
      click_button("Fulfill Item")
    end

    @item2.reload

    expect(@item2.inventory).to eq(1)
  end 
end

# As a merchant employee
# When I visit an order show page from my dashboard
# For each item of mine in the order
# If the user's desired quantity is equal to or less than my current 
# inventory quantity for that item
# And I have not already "fulfilled" that item:
# - Then I see a button or link to "fulfill" that item
# - When I click on that link or button I am returned to the order show page
# - I see the item is now fulfilled
# - I also see a flash message indicating that I have fulfilled that item
# - the item's inventory quantity is permanently reduced by the user's desired quantity

# If I have already fulfilled this item, I see text indicating such.