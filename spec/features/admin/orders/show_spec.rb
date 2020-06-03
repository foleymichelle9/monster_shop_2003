require 'rails_helper'

RSpec.describe "Admin Order Show Page"do

  before :each do
    @regular1 = create(:user, email: 'regular1@email.com')
    @regular2 = create(:user, email: 'regular2@email.com')
    @regular3 = create(:user, email: 'regular3@email.com')
    @admin = create(:user, role: 2)
    @password = 'p123'

    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant)
    @merchant1_user = create(:user, merchant_id: @merchant1.id )
    @merchant2_user = create(:user, merchant_id: @merchant2.id )

    @item1 = create(:item, merchant: @merchant1)
    @item2 = create(:item, merchant: @merchant1)
    @item3 = create(:item, merchant: @merchant2)

    @order10 = create(:order, user: @regular1, status: 3) #cancelled - 4th
    @order11 = create(:order, user: @regular1, status: 1) #packaged - 1st
    @order2 = create(:order, user: @regular2, status: 2) #shipped - 3rd
    @order3 = create(:order, user: @regular3, status: 0) #pending - 2nd

    @item_order1 = ItemOrder.create(order_id: @order10.id, item_id: @item1.id, status: 0, price: @item1.price, quantity: 1)
    @item_order2 = ItemOrder.create(order_id: @order10.id, item_id: @item2.id, status: 0, price: @item2.price, quantity: 1)
    ItemOrder.create(order_id: @order11.id, item_id: @item2.id, status: 1, price: @item2.price, quantity: 1)
    ItemOrder.create(order_id: @order2.id, item_id: @item2.id, status: 1, price: @item2.price, quantity: 2)
    ItemOrder.create(order_id: @order3.id, item_id: @item3.id, status: 1, price: @item3.price, quantity: 3)

    visit '/login'
    within("#login-form")do
      fill_in :email, with: @admin.email
      fill_in :password, with: @password
      click_button "Login"
    end
  end
  it "US55 admin dashboard links to order show" do
    visit "/admin/dashboard"

    within("#order-#{@order11.id}")do
      expect(page).to have_link("Order #{@order11.id}")
    end
    within("#order-#{@order2.id}")do
      expect(page).to have_link("Order #{@order2.id}")
    end
    within("#order-#{@order3.id}")do
      expect(page).to have_link("Order #{@order3.id}")
    end
    within("#order-#{@order10.id}")do
      click_link("Order #{@order10.id}")
    end

    expect(current_path).to eq("/admin/users/#{@regular1.id}/orders/#{@order10.id}")

    
  end

  it "US56 Part I Admin Order View Page From Order Index" do
    visit "/admin/dashboard"
    within("#order-#{@order10.id}")do
      click_link("Order #{@order10.id}")
    end
    expect(current_path).to eq("/admin/users/#{@regular1.id}/orders/#{@order10.id}")

    expect(page).to have_content(@order10.id)
    expect(page).to have_content(@order10.created_at)
    expect(page).to have_content(@order10.updated_at)
    expect(page).to have_content(@order10.status)

    within("#item-#{@item1.id}")do
      expect(page).to have_content(@item1.name)
      expect(page).to have_content(@item1.description)
      expect(page).to have_content(@merchant1.name)
      expect(page).to have_content(@item_order1.price)
      expect(page).to have_content(@item_order1.quantity)
      expect(page).to have_css("img[src*='#{@item1.image}']")
    end
    within("#item-#{@item2.id}")do
      expect(page).to have_content(@item2.name)
      expect(page).to have_content(@item2.description)
      expect(page).to have_content(@merchant1.name)
      expect(page).to have_content(@item_order2.price)
      expect(page).to have_content(@item_order2.quantity)
      expect(page).to have_css("img[src*='#{@item2.image}']")
    end
    expect(page).to_not have_content(@item3.name)

    within("#grandtotal")do
      expect(page).to have_content("Total: $#{@order10.grandtotal}")
    end
  end

  it "US56 Part II Admin Order page from User Page" do
    visit admin_users_path

    click_on @regular1.name
    expect(current_path).to eq(admin_user_path(@regular1))

    click_on "Order #{@order10.id}"
    expect(current_path).to eq("/admin/users/#{@regular1.id}/orders/#{@order10.id}")

  end
  

end

# As an admin user
# When I visit a user's profile
# And I click on a link for order's show page
# My URL route is now something like "/admin/users/5/orders/15"
# I see all information about the order, including the following information:
# - the ID of the order
# - the date the order was made
# - the date the order was last updated
# - the current status of the order
# - each item the user ordered, including name, description, thumbnail, quantity, price and subtotal
# - the total quantity of items in the whole order
# - the grand total of all items for that order