require 'rails_helper'

RSpec.describe 'As an admin user' do 
  describe 'When I click the "Users" link in the nav (only visible to admins)' do
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
      
      @item1 = create(:item, merchant: @merchant1)
      @item2 = create(:item, merchant: @merchant1)
      @item3 = create(:item, merchant: @merchant2)
      @item4 = create(:item, merchant: @merchant3)
      
      
      visit '/login'
      within("#login-form")do
        fill_in :email, with: @admin.email
        fill_in :password, with: 'p123'
        click_button "Login"
      end
    end

    it 'I see all users in the system' do
      visit admin_users_path

      expect(page).to have_link(@merchant1_user.name) 
      expect(page).to have_link(@merchant2_user.name) 
      expect(page).to have_link(@merchant3_user.name) 
      expect(page).to have_content(@merchant1_user.created_at.strftime("%m-%d-%y"))
      expect(page).to have_content(@merchant1_user.role) 
    #   binding.pry
    # save_and_open_page
    end
  end
end



# As an admin user
# When I click the "Users" link in the nav (only visible to admins)
# Then my current URI route is "/admin/users"
# Only admin users can reach this path.
# I see all users in the system
# Each user's name is a link to a show page for that user ("/admin/users/5")
# Next to each user's name is the date they registered
# Next to each user's name I see what type of user they are