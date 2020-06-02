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

  it "US46 cannot create item if details are bad or missing" do
    visit new_merchant_item_path

     within("#new-item-form")do
      fill_in "item[name]", with: "name1"
      fill_in "item[description]", with: ""
      fill_in "item[image]", with: ""
      fill_in "item[price]", with: ""
      fill_in "item[inventory]", with: ""

      click_on "Create Item"
    end

    expect(current_path).to eq(new_merchant_item_path)
    expect(page).to have_content("You must enter a valid description, price, inventory")

    # expect(find_field("item[name]").value).to eq("name1")
    # expect(find_field("item[description]").value).to eq("")


  end
  
end

# User Story 46, Merchant cannot add an item if details are bad/missing

# As a merchant employee
# When I try to add a new item
# x - If any of my data is incorrect or missing (except image)
# x - Then I am returned to the form
# x - I see one or more flash messages indicating each error I caused
#  All fields are re-populated with my previous data