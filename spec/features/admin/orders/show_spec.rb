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
    @item3 = create(:item, merchant: @merchant2, inventory: 10)

    @order10 = create(:order, user: @regular1, status: 3) #cancelled - 4th
    @order11 = create(:order, user: @regular1, status: 1) #packaged - 1st
    @order2 = create(:order, user: @regular2, status: 2) #shipped - 3rd
    @order3 = create(:order, user: @regular3, status: 0) #pending - 2nd

    @item_order1 = ItemOrder.create(order_id: @order10.id, item_id: @item1.id, status: 0, price: @item1.price, quantity: 1)
    @item_order2 = ItemOrder.create(order_id: @order10.id, item_id: @item2.id, status: 0, price: @item2.price, quantity: 1)
    @item_order3 = ItemOrder.create(order_id: @order11.id, item_id: @item2.id, status: 1, price: @item2.price, quantity: 1)
    @item_order4 = ItemOrder.create(order_id: @order2.id, item_id: @item2.id, status: 1, price: @item2.price, quantity: 2)
    @item_order5 = ItemOrder.create(order_id: @order3.id, item_id: @item3.id, status: 1, price: @item3.price, quantity: 3)

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
  it "US57 admin cancels an order and items are unfulfilled and returned to their inventory" do

    visit "/admin/users/#{@regular3.id}/orders/#{@order3.id}"

    within("#cancel-order")do
      click_link "Cancel Order"
    end

    expect(current_path).to eq(admin_dashboard_path)
    expect(page).to have_content("Order #{@order3.id} has been cancelled")

    visit '/items'
    within("#item-#{@item3.id}")do
      expect(page).to have_content("Inventory: 13")
    end

    visit "/admin/users/#{@regular3.id}/orders/#{@order3.id}"

    expect(page).to_not have_css("#cancel-order")

    within(".shipping-address")do
      expect(page).to have_content("cancelled")
    end

    within("#item-#{@item_order5.item_id}")do
      expect(page).to have_content("unfulfilled")
    end
  end
end
