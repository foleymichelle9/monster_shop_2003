require 'rails_helper'

RSpec.describe "Merchant Item New Page" do

  before :each do
    @merchant1 = create(:merchant)
    @merchant_user = create(:user, name: "merchant user", role: 1, merchant_id: @merchant1.id)

    @item100 = create(:item, merchant: @merchant1, price: 100)
    @item101 = create(:item, merchant: @merchant1, price: 101)

    visit '/login'
    within("#login-form")do
      fill_in :email, with: @merchant_user.email
      fill_in :password, with: 'p123'
      click_button "Login"
    end

  end
  it "US45 Merhcant adds items" do
    visit '/merchant/items'
    expect(current_path).to eq(merchant_items_path)

    click_link "Add New Item"

    expect(current_path).to eq('/merchant/items/new')
    expect(current_path).to eq(new_merchant_item_path)

    within("#new-item-form")do
      fill_in "item[name]", with: "name1"
      fill_in "item[description]", with: "description1"
      fill_in "item[image]", with: ""
      fill_in "item[price]", with: 10
      fill_in "item[inventory]", with: 100

      click_on "Create Item"
    end

    item = Item.last

    expect(current_path).to eq('/merchant/items')
    expect(current_path).to eq(merchant_items_path)
    expect(page).to have_content("Item #{item.id} has been created")

    within("#item-#{item.id}")do
      expect(page).to have_content("Name: name1")
      expect(page).to have_content("Description: description1")
      expect(page).to have_css("img[src*='https://www.pngitem.com/pimgs/m/187-1877177_packaging-box-opened-outline-box-outline-hd-png.png']")
      expect(page).to have_content("Price: $10.00")
      expect(page).to have_content("Inventory: 100")
      expect(page).to have_content("Active? true")
    end
    within("#item-#{@item100.id}")do
      expect(page).to have_content(@item100.name)
    end
    within("#item-#{@item101.id}")do
      expect(page).to have_content(@item101.name)
    end

    
  end
end

# As a merchant employee
# x- When I visit my items page
# x- I see a link to add a new item
# When I click on the link to add a new item
# I see a form where I can add new information about an item, including:
# x- the name of the item, which cannot be blank
# x- a description for the item, which cannot be blank
# x- a thumbnail image URL string, which CAN be left blank
# x- a price which must be greater than $0.00
# x- my current inventory count of this item which is 0 or greater

# When I submit valid information and submit the form
# x - I am taken back to my items page
# x - I see a flash message indicating my new item is saved
# x - I see the new item on the page, and it is enabled and available for sale
# x - If I left the image field blank, I see a placeholder image for the thumbnail