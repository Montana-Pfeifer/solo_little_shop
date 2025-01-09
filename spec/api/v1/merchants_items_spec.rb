require 'rails_helper'

RSpec.describe "MerchantsItems API", type: :request do
  before(:each) do
    @merchant_one = Merchant.create!(name: 'Matt\'s Computer Repair Store')
    @merchant_two = Merchant.create!(name: 'Natasha\'s Taylor Swift Store')
    @merchant_three = Merchant.create!(name: 'Montana\'s Pokemon Cards Store')

    @item1 = Item.create!(
      name: "New Monitor",
      description: "32' ViewSonic Gaming Monitor",
      unit_price: 350.00,
      merchant_id: @merchant_one.id
    )

    @item2 = Item.create!(
      name: "Keyboard",
      description: "Clickity Clackity Keyboard",
      unit_price: 50.00,
      merchant_id: @merchant_one.id
    )

    @item3 = Item.create!(
      name: "Mouse",
      description: "Fancy Gaming Mouse",
      unit_price: 35.00,
      merchant_id: @merchant_one.id
    )

    @item4 = Item.create!(
      name: "TTDP sweater",
      description: "I cry a lot but I am so productive",
      unit_price: 65.00,
      merchant_id: @merchant_two.id
    )

    @item5 = Item.create!(
      name: "TTPD sweatpants",
      description: "Down bad crying at the gym",
      unit_price: 70.00,
      merchant_id: @merchant_two.id
    )

    @item6 = Item.create!(
      name: "Pokemon Cards",
      description: "Pack of Pokemon Cards",
      unit_price: 45.00,
      merchant_id: @merchant_three.id
    )

    @item6 = Item.create!(
      name: "MTG Cards",
      description: "Pack of Magic The Gathering Cards",
      unit_price: 45.00,
      merchant_id: @merchant_three.id
    )
  end

  describe 'GET /api/v1/merchants/:id/items' do
    it 'fetches all items that belong to a specific merchant id' do

      get "/api/v1/merchants/#{@merchant_two.id}/items"
      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)[:data]
    
      items.each do |item|
        expect(item[:id]).to be_a(String)
        expect(item[:type]).to eq('item')
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes][:description]).to be_a(String)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end

      expect(items[0][:attributes][:name]).to eq("TTDP sweater")
      expect(items[1][:attributes][:name]).to eq("TTPD sweatpants")
      expect(items[0][:attributes][:description]).to eq("I cry a lot but I am so productive")
      expect(items[1][:attributes][:description]).to eq("Down bad crying at the gym")
      expect(items[0][:attributes][:unit_price]).to eq(65.00)
      expect(items[1][:attributes][:unit_price]).to eq(70.00)
      expect(items[0][:attributes][:merchant_id]).to eq(@merchant_two.id)
      expect(items[1][:attributes][:merchant_id]).to eq(@merchant_two.id)
    end

    it 'displays 404 error if merchant cannot be found' do
      get "/api/v1/merchants/133713371337/items"
   
      expect(response.status).to eq(404)
      expect(response.body).to include("Record Not Found")
    end
  end
end