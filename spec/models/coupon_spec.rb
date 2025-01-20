require 'rails_helper'

RSpec.describe Coupon, type: :model do
  before(:each) do
    @customer = Customer.create!(first_name: "John", last_name: "Doe")

    @merchant = Merchant.create!(name: "Test Merchant")
    @coupon1 = Coupon.create!(name: "Discount 1", code: "SAVE10", discount_type: "percentage", value: 10, merchant: @merchant)
    @coupon2 = Coupon.create!(name: "Discount 2", code: "SAVE20", discount_type: "fixed", value: 20, merchant: @merchant)

    @invoice1 = Invoice.create!(merchant: @merchant, coupon: @coupon1, customer: @customer, status: "pending")
    @invoice2 = Invoice.create!(merchant: @merchant, coupon: @coupon2, customer: @customer, status: "completed")
  end

  describe "validations" do
    it "is valid with valid attributes" do
      coupon = Coupon.new(name: "Extra Discount", code: "EXTRA10", discount_type: "percentage", value: 15, merchant: @merchant)

      expect(coupon).to be_valid
      expect(coupon.name).to eq("Extra Discount")
      expect(coupon.code).to eq("EXTRA10")
      expect(coupon.discount_type).to eq("percentage")
      expect(coupon.value).to eq(15)
    end

    it "is invalid without required attributes" do
      coupon = Coupon.new(merchant: @merchant)

      expect(coupon).not_to be_valid
      expect(coupon.errors.full_messages).to include(
        "Name can't be blank",
        "Code can't be blank",
        "Discount type can't be blank",
        "Value can't be blank"
      )
    end

    it "validates uniqueness of code scoped to merchant" do
      duplicate_coupon = Coupon.new(name: "Duplicate Discount", code: "SAVE10", discount_type: "percentage", value: 15, merchant: @merchant)

      expect(duplicate_coupon).not_to be_valid
      expect(duplicate_coupon.errors.full_messages).to include("Code has already been taken for this merchant")
    end
  end

  describe "relationships" do
    it "belongs to a merchant" do
      expect(@coupon1.merchant).to eq(@merchant)
    end

    it "has many invoices" do
      expect(@coupon1.invoices).to include(@invoice1)
      expect(@coupon2.invoices).to include(@invoice2)
    end
  end

  describe "custom methods" do
    it "checks if a merchant has reached the coupon limit" do
      3.times do |i|
        Coupon.create!(name: "Extra Discount #{i}", code: "EXTRA#{i}", discount_type: "percentage", value: 15, merchant: @merchant)
      end

      new_coupon = Coupon.new(name: "Excess Discount", code: "EXCESS", discount_type: "fixed", value: 5, merchant: @merchant)

      expect(new_coupon).not_to be_valid
      expect(new_coupon.errors.full_messages).to include("Merchant cannot have more than 5 coupons")
    end

    it "validates uniqueness of coupon code scoped to the merchant" do
      duplicate_coupon = Coupon.new(name: "Discount 1", code: "SAVE10", discount_type: "percentage", value: 10, merchant: @merchant)
      duplicate_coupon.valid?

      expect(duplicate_coupon).not_to be_valid
      expect(duplicate_coupon.errors.full_messages).to include("Code has already been taken for this merchant")
    end

    it "allows duplicate coupon codes for different merchants" do
      other_merchant = Merchant.create!(name: "Other Merchant")
      valid_coupon = Coupon.new(name: "Same Code Different Merchant", code: "SAVE10", discount_type: "percentage", value: 15, merchant: other_merchant)
    
      expect(valid_coupon).to be_valid
    end
    
  end
end
