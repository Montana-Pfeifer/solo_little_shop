require 'rails_helper'

RSpec.describe "Items API", type: :request do
    before(:each) do
    
        @merchant = Merchant.create!(name: 'Taylor Swift Store')

        @item1 = Item.create!(
            name: "TTDP sweater",
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
    end

    describe 'GET /api/v1/items' do
        it 'fetches all items' do

            get '/api/v1/items'

            expect(response).to be_successful
            expect(response.status).to eq(200)

            items = JSON.parse(response.body, symbolize_names: true)[:data]
        
            item = items[0]
            expect(item[:id]).to be_a(String)
            expect(item[:type]).to eq('item')

            expect(item[:attributes][:name]).to be_a(String)
            expect(item[:attributes][:description]).to be_a(String)
            expect(item[:attributes][:unit_price]).to be_a(Float)
            expect(item[:attributes][:merchant_id]).to be_an(Integer)
        end

        it 'fetches a single item' do
            get "/api/v1/items/#{@item1.id}"

            expect(response).to be_successful
            expect(response.status).to eq(200)

            item = JSON.parse(response.body, symbolize_names: true)[:data]

            expect(item[:id].to_i).to eq(@item1.id)
            expect(item[:type]).to eq('item')

            expect(item[:attributes][:name]).to eq(@item1.name)
            expect(item[:attributes][:description]).to eq(@item1.description)
            expect(item[:attributes][:unit_price]).to eq(@item1.unit_price)
            expect(item[:attributes][:merchant_id]).to eq(@item1.merchant_id)
        end
    end
end