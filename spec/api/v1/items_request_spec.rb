require 'rails_helper'

RSpec.describe "Items API", type: :request do
    before(:each) do
    
        @merchant = Merchant.create!(name: 'Taylor Swift Store')

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

        it 'can sort all items by price (low to high)' do

            get '/api/v1/items', params: { sorted: 'price'}

            expect(response).to be_successful
            expect(response.status).to eq(200)

            items = JSON.parse(response.body, symbolize_names: true)[:data]

            expect(items[0][:attributes][:name]).to eq("Evermore tee")
            expect(items[1][:attributes][:name]).to eq("Rep ring")
            expect(items[2][:attributes][:name]).to eq("TTPD sweater")
            expect(items[3][:attributes][:name]).to eq("TTPD sweatpants")
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

        it 'displays a 404 when record is not found' do
            get "/api/v1/items/999999"
        
            expect(response.status).to eq(404)
            expect(response.body).to include("Record Not Found")
        end
    end

    describe 'POST /api/v1/items' do
        it 'can create an item' do

            new_item = {
                name: "Midnights sweater",
                description: "It's me, hi, I'm the problem, it's me",
                unit_price: 65.00,
                merchant_id: @merchant.id
            }
            post '/api/v1/items', params: {item: new_item} 

            expect(response).to be_successful

            item = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]

            expect(item[:name]).to eq("Midnights sweater")
            expect(item[:description]).to eq("It's me, hi, I'm the problem, it's me")
            expect(item[:unit_price]).to eq(65.00)
            expect(item[:merchant_id]).to eq(@merchant.id)
        end

        it 'returns a 422 when required parameters are missing' do
            new_item = {
            name: "",
            description: "It's me, hi, I'm the problem, it's me",
            unit_price: 65.00,
            merchant_id: @merchant.id
            }
        
            post "/api/v1/items", params: { item: new_item }
        
            expect(response.status).to eq(422)
            expect(response.body).to include("Name can't be blank")
        end

        it 'returns a 400 bad request for parse errors' do
    
            post "/api/v1/items", 
            params: '{ invalid_json: "malformed }', 
            headers: { 'Content-Type' => 'application/json' }
            
            expect(response.status).to eq(400)
            expect(response.body).to include('Bad Request')
            expect(response.body).to include('Error occurred while parsing request parameters')
        end

        it 'returns a 400 when required parameters are missing' do
            post "/api/v1/items", params: { item: { } }
        
            expect(response.status).to eq(400)
            expect(response.body).to include("Bad Request")
            expect(response.body).to include('param is missing or the value is empty: item')

        end
    end

    describe 'PUT /api/v1/items/:id'do
        it 'can update an existing item' do

            old_name = @item1.name

            new_params = {
                name: "Rep crew",
                description: "I'm on my Vigilante Shit again",
                unit_price: 70.00
            }

            put "/api/v1/items/#{@item1.id}", params: { item: new_params}
            item = Item.find_by(id: @item1.id)

            expect(response).to be_successful
            expect(item.name).to_not eq(old_name)
            expect(item.name).to eq("Rep crew")
            expect(item.description).to eq("I'm on my Vigilante Shit again")
            expect(item.unit_price).to eq(70.00)

        end

        it 'returns error when provided invalid merchant id on update of item' do

            old_name = @item1.name

            new_params = {
                name: "Rep crew",
                description: "I'm on my Vigilante Shit again",
                unit_price: 70.00,
                merchant_id: 99999999999999
            }

            put "/api/v1/items/#{@item1.id}", params: { item: new_params}
            item = Item.find_by(id: @item1.id)

            expect(response.status).to eq(404)
            expect(item.name).to eq(old_name)
            expect(item.description).to eq("I cry a lot but I am so productive")
            expect(item.unit_price).to eq(65.00)
            expect(item.merchant_id).to eq(@merchant.id)

        end
    end

    describe 'DELETE /api/v1/items/:id' do
        it 'can delete an existing item' do
        
            items = Item.all
            expect(items.count).to eq(4)
    
            delete "/api/v1/items/#{@item1.id}"
    
            expect(items.count).to eq(3)
        end
    end
    
    describe '.find_all' do
        it 'returns items filtered by name' do
            get '/api/v1/items/find_all', params: { name: 'tTPd' }

    
            expect(response).to be_successful
            expect(response.status).to eq(200)
    
            items = JSON.parse(response.body, symbolize_names: true)[:data]
            expect(items.count).to eq(2)
            expect(items[0][:attributes][:name]).to eq('TTPD sweater')
        end
  
        it 'filters items by price range correctly' do
            get '/api/v1/items/find_all', params: { min_price: 50, max_price: 70 }
          
            expect(response).to be_successful
            items = JSON.parse(response.body, symbolize_names: true)[:data]
            prices = items.map { |item| item[:attributes][:unit_price] }
          
            expect(prices).to all(be_between(50, 70))
            expect(prices).to include(50.0, 70.0)
            expect(prices).not_to include(35.0, 100.0)
          end
          
        
                
    
        it 'returns error if name and price range are provided' do
            get '/api/v1/items/find_all', params: { name: 'widget', min_price: 50 }
          
            expect(response.status).to eq(400)
            expect(response.body).to include('Cannot search by name and price range simultaneously')
        end
    
        it 'returns error for invalid price format' do
            get '/api/v1/items/find_all', params: { min_price: 'abc', max_price: 50 }
          
            expect(response.status).to eq(400)
            expect(response.body).to include('Price must be a valid number')
        end
          
    
        it 'returns all items when no parameters are passed' do
            get '/api/v1/items/find_all', params: { }
    
            expect(response).to be_successful
            expect(response.status).to eq(200)
    
            items = JSON.parse(response.body, symbolize_names: true)[:data]
            expect(items.count).to eq(4)
        end
    end
end