require 'rails_helper'

RSpec.describe Merchant, type: :model do
  before(:each) do
    @merchant_one = Merchant.create!(name: "Matt's Computer Repair Store")
    @merchant_two = Merchant.create!(name: "Natasha's Taylor Swift Store")
    @merchant_three = Merchant.create!(name: "Montana's Pokemon Cards Store")

    @coupon1 = Coupon.create!(name: "Discount 1", code: "SAVE10", discount_type: "percentage", value: 10, merchant: @merchant_one)
    @coupon2 = Coupon.create!(name: "Discount 2", code: "SAVE20", discount_type: "fixed", value: 20, merchant: @merchant_one)
    @coupon3 = Coupon.create!(name: "Discount 3", code: "SAVE30", discount_type: "percentage", value: 15, merchant: @merchant_one)
    @coupon4 = Coupon.create!(name: "Discount 4", code: "SAVE40", discount_type: "fixed", value: 25, merchant: @merchant_one)
    @coupon5 = Coupon.create!(name: "Discount 5", code: "SAVE50", discount_type: "percentage", value: 30, merchant: @merchant_one)
    
    @item1 = Item.create!(
          name: "TTPD sweater",
          description: "I cry a lot but I am so productive",
          unit_price: 65.00,
          merchant_id: @merchant_one.id
        )

    @item2 = Item.create!(
        name: "TTPD sweatpants",
        description: "Down bad crying at the gym",
        unit_price: 70.00,
        merchant_id: @merchant_one.id
        )

    @item3 = Item.create!(
        name: "Rep ring",
        description: "Snake ring",
        unit_price: 50.00,
        merchant_id: @merchant_two.id
        )

  end
  
  describe "relationships" do
    it { should have_many :invoices }
    it { should have_many :items }
  end

  describe '.find_by_name' do
    it 'returns merchants with names matching the search term' do
      result = Merchant.find_by_name('Taylor')
      
      expect(result).to include(@merchant_two)  
      expect(result).not_to include(@merchant_one, @merchant_three) 
    end

    it 'returns merchants with names that partially match the search term' do
      result = Merchant.find_by_name('Store')
      
      expect(result).to include(@merchant_one, @merchant_two, @merchant_three)
    end

    it 'returns no merchants if there is no match' do
      result = Merchant.find_by_name('Nonexistent Store')
      
      expect(result).to be_empty
    end
  end

  describe "has_reached_coupon_limit?" do
    it "returns true if the merchant has 5 or more coupons" do
      expect(@merchant_one.has_reached_coupon_limit?).to be true
    end

    it "returns false if the merchant has fewer than 5 coupons" do
      Coupon.create!(name: "Discount 6", code: "SAVE60", discount_type: "percentage", value: 20, merchant: @merchant_three)
      expect(@merchant_three.has_reached_coupon_limit?).to be false
    end
  end

  describe "self.merchants_by_age" do
    it "returns merchants ordered by creation date in descending order" do
      # Adjust creation dates for the existing merchants
      @merchant_one.update_columns(created_at: 2.days.ago)
      @merchant_two.update_columns(created_at: 1.day.ago)
      @merchant_three.update_columns(created_at: 3.days.ago)

      merchants = Merchant.merchants_by_age

      expect(merchants.first).to eq(@merchant_two)
      expect(merchants.second).to eq(@merchant_one)
      expect(merchants.last).to eq(@merchant_three) 
    end
  end
  describe "self.merchants_with_returns" do
    it "returns merchants with at least one returned invoice" do
      customer = Customer.create!(first_name: "Jane", last_name: "Doe")
      merchant_with_returns = Merchant.create!(name: "Merchant with Returns")
      merchant_without_returns = Merchant.create!(name: "Merchant without Returns")

      invoice1 = Invoice.create!(merchant: merchant_with_returns, customer: customer, status: 'returned')
      invoice2 = Invoice.create!(merchant: merchant_without_returns, customer: customer, status: 'completed')

      merchants_with_returns = Merchant.merchants_with_returns
      expect(merchants_with_returns).to include(merchant_with_returns)
      expect(merchants_with_returns).not_to include(merchant_without_returns)
    end
  end

  describe "self.fetch_all_items" do
    it "returns all items associated with the merchant" do
      items_for_merchant_one = Merchant.fetch_all_items(@merchant_one)
  
      # Check that items for @merchant_one are included
      expect(items_for_merchant_one).to include(@item1, @item2)
      expect(items_for_merchant_one).not_to include(@item3)
  
      items_for_merchant_two = Merchant.fetch_all_items(@merchant_two)
  
      expect(items_for_merchant_two).to include(@item3)
      expect(items_for_merchant_two).not_to include(@item1, @item2)
    end
  end
  
end
