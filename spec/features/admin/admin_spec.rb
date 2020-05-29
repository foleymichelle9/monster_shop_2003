require "rails_helper"


describe User do
  describe "roles" do
    before :each do
      @regular1 = create(:user, email: 'regular@email.com')
      @merchant1 = create(:user, email: 'merchant@eamil.com',role: 1)
      @admin1 = create(:user, email: 'admin@eamil.com',role: 2)
      @password = 'p123'

      
    end
    it "can be created as an admin" do

      expect(@admin1.role).to eq("admin")
      expect(@admin1.admin?).to be_truthy

      visit '/login'

      within("#login-form")do
        fill_in :email, with: @admin1.email
        fill_in :password, with: @password
        click_button "Login"
      end
      click_link "Dashboard"
    end
  end
end
