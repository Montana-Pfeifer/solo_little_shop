require 'rails_helper'

RSpec.describe Invoice, type: :model do
  before(:each) do
    # Create merchants
    @merchant_one = Merchant.create!(name: "Matt's Computer Repair Store")
    @merchant_two = Merchant.create!(name: "Natasha's Taylor Swift Store")

    @customer_one = Customer.create!(first_name: "Jane", last_name: "Doe")

    @invoice_one = Invoice.create!(merchant: @merchant_one, customer: @customer_one, status: 'shipped')
    @invoice_two = Invoice.create!(merchant: @merchant_one, customer: @customer_one, status: 'returned')
    @invoice_three = Invoice.create!(merchant: @merchant_one, customer: @customer_one, status: 'packaged')
    @invoice_four = Invoice.create!(merchant: @merchant_one, customer: @customer_one, status: 'completed')

    @invoice_five = Invoice.create!(merchant: @merchant_two, customer: @customer_one, status: 'shipped')
    @invoice_six = Invoice.create!(merchant: @merchant_two, customer: @customer_one, status: 'completed')

  end

  describe "relationships" do
    it { should belong_to :customer }
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many :transactions }
  end

  describe "self.find_all_invoices" do
    it "returns all invoices for the given merchant" do
      invoices_for_merchant_one = Invoice.find_all_invoices(@merchant_one)

      expect(invoices_for_merchant_one).to include(@invoice_one, @invoice_two, @invoice_three, @invoice_four)
      expect(invoices_for_merchant_one).not_to include(@invoice_five, @invoice_six)
    end
  end

  describe "self.find_shipped_invoices" do
    it "returns invoices with status 'shipped' for the given merchant" do
      shipped_invoices_for_merchant_one = Invoice.find_shipped_invoices(@merchant_one)

      expect(shipped_invoices_for_merchant_one).to include(@invoice_one)
      expect(shipped_invoices_for_merchant_one).not_to include(@invoice_two, @invoice_three, @invoice_four)

      shipped_invoices_for_merchant_two = Invoice.find_shipped_invoices(@merchant_two)
      
      expect(shipped_invoices_for_merchant_two).to include(@invoice_five)
      expect(shipped_invoices_for_merchant_two).not_to include(@invoice_six)
    end
  end

  describe "self.find_returned_invoices" do
    it "returns invoices with status 'returned' for the given merchant" do
      returned_invoices_for_merchant_one = Invoice.find_returned_invoices(@merchant_one)

      expect(returned_invoices_for_merchant_one).to include(@invoice_two)
      expect(returned_invoices_for_merchant_one).not_to include(@invoice_one, @invoice_three, @invoice_four)

      returned_invoices_for_merchant_two = Invoice.find_returned_invoices(@merchant_two)

      expect(returned_invoices_for_merchant_two).to be_empty
    end
  end

  describe "self.find_packaged_invoices" do
    it "returns invoices with status 'packaged' for the given merchant" do
      packaged_invoices_for_merchant_one = Invoice.find_packaged_invoices(@merchant_one)

      expect(packaged_invoices_for_merchant_one).to include(@invoice_three)
      expect(packaged_invoices_for_merchant_one).not_to include(@invoice_one, @invoice_two, @invoice_four)

      packaged_invoices_for_merchant_two = Invoice.find_packaged_invoices(@merchant_two)

      expect(packaged_invoices_for_merchant_two).to be_empty
    end
  end
end