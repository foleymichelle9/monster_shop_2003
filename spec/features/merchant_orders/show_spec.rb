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
    @item1 = create(:item, merchant: @merchant1)
    @item2 = create(:item, merchant: @merchant1)
    @item3 = create(:item, merchant: @merchant2)
  
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
  
  it "US31 part I - merchant can fulfil orders" do
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
  
  
end