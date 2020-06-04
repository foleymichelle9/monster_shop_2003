require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it {should validate_presence_of :name}
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
    it {should validate_uniqueness_of :email}
    it {should validate_presence_of :password}
  end
  describe "relationships" do
    it {should have_many :orders}
    it {should belong_to(:merchant).optional}
  end
  describe "instance methods" do
    it "full_address" do
      user = create(:user)

      expect(user.full_address).to eq("#{user.address}, #{user.city}, #{user.state}, #{user.zip}")
    end
  end
end