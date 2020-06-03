require 'rails_helper'

RSpec.describe 'As an admin user' do 
  describe 'when I visit a users profile page("/admin/users/5")' do
    before :each do
      @admin = create(:user, role: 2)

      @merchant1 = create(:merchant)
      @merchant2 = create(:merchant, active?: false)
      @merchant3 = create(:merchant)

      @merchant1_user = create(:user, role: 1, merchant_id: @merchant1.id)
      @merchant2_user = create(:user, role: 1, merchant_id: @merchant2.id)
      @merchant3_user = create(:user, role: 1, merchant_id: @merchant3.id)
      @regular1 = User.create!(name: "User Name1", address: "user address1", city: "user city", state: "state", zip: "user zip", email: "user1", password: "user", role: 0)
      @regular2 = User.create!(name: "User Name2", address: "user address2", city: "user city", state: "state", zip: "user zip", email: "user2", password: "user", role: 0)
      @regular3 = User.create!(name: "User Name3", address: "user address3", city: "user city", state: "state", zip: "user zip", email: "user3", password: "user", role: 0)
      
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
      
      
      visit '/login'
      within("#login-form")do
        fill_in :email, with: @admin.email
        fill_in :password, with: 'p123'
        click_button "Login"
      end
    end
    
    it 'I see the same information the user would see themselves' do

      within 'nav' do
        click_link"Users"
      end 
      expect(current_path).to eq(admin_users_path)

      click_link"#{@regular1.name}"

      expect(current_path).to eq("/admin/users/#{@regular1.id}")
      expect(page).to have_content(@regular1.name)
      expect(page).to have_content(@regular1.address)
      expect(page).to have_content(@regular1.city)
      expect(page).to have_content(@regular1.state)
      expect(page).to have_content(@regular1.zip)
      expect(page).to have_content(@regular1.email) 
      # click_link"Their Orders
    end
  end
end


# As an admin user
# When I visit a user's profile page ("/admin/users/5")
# I see the same information the user would see themselves
# I do not see a link to edit their profile    