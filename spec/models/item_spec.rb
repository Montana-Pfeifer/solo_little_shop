require 'rails_helper'

RSpec.describe Item, type: :model do

  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
  end

  describe 'validations' do

    it 'is valid with all attributes' do
      merchant = Merchant.create(name: 'Taylor Swift Store')
      new_item = Item.create(
        name: "TTPD ring",
        description: "It's a ring",
        unit_price: 40.00,
        merchant_id: merchant.id
      )

      expect(new_item).to be_valid
    end

    it 'is invalid wihtout a name' do
      merchant = Merchant.create(name: 'Taylor Swift Store')
      new_item = Item.create(
        description: "It's a ring",
        unit_price: 40.00,
        merchant_id: merchant.id
      )

      expect(new_item).to_not be_valid
    end

    it 'is invalid without a description' do
      merchant = Merchant.create!(name: 'Taylor Swift Store')
      new_item = Item.create(
        name: "TTPD ring",
        unit_price: 40.00,
        merchant_id: merchant.id
      )

      expect(new_item).to_not be_valid
    end

    it 'is invalid without a unit price' do
      merchant = Merchant.create!(name: 'Taylor Swift Store')
      new_item = Item.create(
        name: "TTPD ring",
        description: "It's a ring",
        merchant_id: merchant.id
      )

      expect(new_item).to_not be_valid
    end

    it 'is invalid without a merchant id' do
      merchant = Merchant.create!(name: 'Taylor Swift Store')
      new_item = Item.create(
        name: "TTPD ring",
        description: "It's a ring",
        unit_price: 40.00
      )

      expect(new_item).to_not be_valid
    end
  end
end