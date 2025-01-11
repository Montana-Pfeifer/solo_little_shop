require 'rails_helper'

RSpec.describe Merchant, type: :model do

  before(:each) do
    @merchant_one = Merchant.create!(name: "Matt's Computer Repair Store")
    @merchant_two = Merchant.create!(name: "Natasha's Taylor Swift Store")
    @merchant_three = Merchant.create!(name: "Montana's Pokemon Cards Store")
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
end