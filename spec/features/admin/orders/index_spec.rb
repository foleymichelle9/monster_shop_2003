require 'rails_helper'

RSpec.describe "Admin Order Index page"do
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

    ItemOrder.create(order_id: @order10.id, item_id: @item1.id, status: 0, price: @item1.price, quantity: 1)
    ItemOrder.create(order_id: @order10.id, item_id: @item2.id, status: 0, price: @item2.price, quantity: 1)
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

  it "US32 admin can see all orders" do
    visit '/admin/dashboard'

    within("#order-#{@order10.id}")do
      expect(page).to have_content("Ordered by: #{@order10.user.name}")
      expect(page).to_not have_content("Ordered by: #{@order2.user.name}")
      expect(page).to have_content("Order id: #{@order10.id}")
      expect(page).to_not have_content("Order id: #{@order11.id}")
      expect(page).to have_content("Created at: #{@order10.created_at}")
    end
    within("#order-#{@order11.id}")do
      expect(page).to have_content("Ordered by: #{@order11.user.name}")
      expect(page).to have_content("Order id: #{@order11.id}")
      expect(page).to have_content("Created at: #{@order11.created_at}")
    end
    within("#order-#{@order2.id}")do
      expect(page).to have_content("Ordered by: #{@order2.user.name}")
      expect(page).to have_content("Order id: #{@order2.id}")
      expect(page).to have_content("Created at: #{@order2.created_at}")
    end
    within("#order-#{@order3.id}")do
      expect(page).to have_content("Ordered by: #{@order3.user.name}")
      expect(page).to have_content("Order id: #{@order3.id}")
      expect(page).to have_content("Created at: #{@order3.created_at}")
    end
    # this isnt working for some reason? need help.

    # expect("#packaged").to appear_before("#pending")
    # expect(@order3.id).to appear_before(@order2.id)
    # expect(@order2.id).to appear_before(@order10.id)
    
  end

  it "US33 admin can ship packaged orders" do
    visit '/admin/dashboard'

    within("#order-#{@order10.id}")do
      expect(page).to_not have_button("Ship Order")
    end
    within("#order-#{@order11.id}")do
      expect(page).to have_content("Order Status: packaged")
      click_button("Ship Order")
    end
    expect(current_path).to eq('/admin/dashboard')
    expect(page).to have_content("Order #{@order11.id} has been shipped")
    within("#order-#{@order11.id}")do
      expect(page).to have_content("Order Status: shipped")
      expect(page).to_not have_button("Ship Order")
    end
    within("#order-#{@order2.id}")do
      expect(page).to_not have_button("Ship Order")
    end
    within("#order-#{@order3.id}")do
      expect(page).to_not have_button("Ship Order")
    end

  
  end
  
end