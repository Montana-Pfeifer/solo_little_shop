require 'rails_helper'
RSpec.describe Customer, type: :model do
  before(:each) do
    @merchant_one = Merchant.create!(name: "Matt's Computer Repair Store")
    @merchant_two = Merchant.create!(name: "Natasha's Taylor Swift Store")

    @customer_one = Customer.create!(first_name: "Jane", last_name: "Doe")
    @customer_two = Customer.create!(first_name: "John", last_name: "Smith")
    @customer_three = Customer.create!(first_name: "Sarah", last_name: "Jones")

    @invoice_one = Invoice.create!(customer: @customer_one, merchant: @merchant_one, status: 'completed')
    @invoice_two = Invoice.create!(customer: @customer_two, merchant: @merchant_one, status: 'completed')

    @invoice_three = Invoice.create!(customer: @customer_three, merchant: @merchant_two, status: 'completed')
    @invoice_four = Invoice.create!(customer: @customer_one, merchant: @merchant_two, status: 'completed')

    @merchant_one.reload
    @merchant_two.reload
    @customer_one.reload
    @customer_two.reload
    @customer_three.reload
  end

  describe "self.fetch_customers_per_merchant" do
    it "returns customers associated with the given merchant" do
      customers_for_merchant_one = Customer.fetch_customers_per_merchant(@merchant_one)

      expect(customers_for_merchant_one).to include(@customer_one, @customer_two)
      expect(customers_for_merchant_one).not_to include(@customer_three)

      customers_for_merchant_two = Customer.fetch_customers_per_merchant(@merchant_two)

      expect(customers_for_merchant_two).to include(@customer_one, @customer_three)
      expect(customers_for_merchant_two).not_to include(@customer_two) 
    end
  end
end
