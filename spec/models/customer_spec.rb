require 'rails_helper'


RSpec.describe Customer, type: :model do
  describe "relationships" do

    it "validates customer" do
      customer = Customer.create!(first_name: "John", last_name: "Smith")

      expect(customer.first_name?).to be(true)
      expect(customer.last_name?).to be(true)

    end
    
    it "shows an error when customer isn't valid" do
      customer = Customer.create!(first_name: "", last_name: "Smith")

      expect(customer.first_name?).to be(false)
    end
  end
end