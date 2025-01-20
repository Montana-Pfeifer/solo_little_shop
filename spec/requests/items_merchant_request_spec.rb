require 'rails_helper'

RSpec.describe "Items API", type: :request do
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

    describe 'GET /api/v1/items/:id/merchant' do
        it 'fetches an items merchant' do

            get "/api/v1/items/#{@item3.id}/merchant"
            expect(response).to be_successful
            expect(response.status).to eq(200)

            merchant = JSON.parse(response.body, symbolize_names: true)[:data]

            expect(merchant[:attributes][:name]).to eq("Taylor Swift Store")
        end

        it 'displays 404 error if merchant cannot be found' do
            get "/api/v1/items/9999/merchant"
    
        expect(response.status).to eq(404)
        expect(response.body).to include("Record Not Found")
        end
    end
end