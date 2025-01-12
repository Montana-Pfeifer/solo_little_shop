require 'rails_helper'

RSpec.describe Item, type: :model do
  before(:each) do
    @merchant = Merchant.create!(name: 'Taylor Swift Store')
        @another_merchant = Merchant.create!(name: 'TS Era Tou')

        @item1 = Item.create!(
            name: "TTPD sweater",
            description: "I cry a lot but I am so productive",
            unit_price: 65.00,
            merchant_id: @merchant.id
        )

        @item2 = Item.create!(
            name: "TTPD sweatpants",
            description: "Down bad crying at the gym",
            unit_price: 70.00,
            merchant_id: @merchant.id
        )

        @item3 = Item.create!(
            name: "Rep ring",
            description: "Snake ring",
            unit_price: 50.00,
            merchant_id: @merchant.id
        )

        @item4 = Item.create!(
            name: "Evermore tee",
            description: "What a shame she's F##### in the head, they said",
            unit_price: 35.00,
            merchant_id: @merchant.id
        )

        @item5 = Item.create!(
            name: "Eras Tour tee",
            description: "It's been a long time coming",
            unit_price: 45.00,
            merchant_id: @another_merchant.id
        )
  end

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

  describe 'sorting' do
    it 'can sort items based on price (low to high)' do

    sorted = Item.sort_by_price
    expect(sorted).to eq([@item4, @item5, @item3, @item1, @item2])
  
    end
  end

  describe 'getting an items merchant' do
    it 'can return an items merchant' do

      result1 = Item.fetch_merchant(@item4)
      result2 = Item.fetch_merchant(@item5)
      result3 = Item.fetch_merchant(@item1)

      expect(result1).to eq(@merchant)
      expect(result2).to eq(@another_merchant)
      expect(result3).to eq(@merchant)
    end
  end

  describe '.find_by_name' do
    it 'finds items matching the name fragment' do
      result = Item.find_by_name('TTPD')
      expect(result).to include(@item1, @item2)
      expect(result).not_to include(@item3, @item4, @item5)
    end

    it 'is case-insensitive' do
      result = Item.find_by_name('ttpd')
      expect(result).to include(@item1, @item2)
    end

    it 'returns an empty array if no match is found' do
      result = Item.find_by_name('bracelet')
      expect(result).to be_empty
    end
  end

  describe '.find_by_price' do
    
    it 'returns items within the price range' do
      result = Item.find_by_price(min_price: 40, max_price: 70)
      expect(result).to include(@item1, @item2, @item3, @item5)
      expect(result).not_to include(@item4)
    end

    it 'returns items greater than or equal to the min_price' do
      result = Item.find_by_price(min_price: 50)
      expect(result).to include(@item1, @item2, @item3)
      expect(result).not_to include(@item4, @item5)
    end
    
    it 'returns items less than or equal to the max_price' do
      result = Item.find_by_price(max_price: 60)
      expect(result).to include(@item4, @item5, @item3)
      expect(result).not_to include(@item1, @item2)
    end

    it 'returns all items' do
      result = Item.find_by_price({})
      expect(result).to include(@item1, @item2, @item3, @item4, @item5)
    end

    it 'returns an empty array' do
      result = Item.find_by_price(min_price: 100)
      expect(result).to be_empty
    end
  end
end