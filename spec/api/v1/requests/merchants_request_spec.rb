require 'rails_helper'

RSpec.describe "Merchants API", type: :request do
  before(:each) do
    @merchant_one = Merchant.create!(name: 'Matt\'s Computer Repair Store')
    @merchant_two = Merchant.create!(name: 'Natasha\'s Taylor Swift Store')
    @merchant_three = Merchant.create!(name: 'Montana\'s Pokemon Cards Store')

    @customer = Customer.create!(first_name: 'John', last_name: 'Doe')

    @invoice_one = @merchant_one.invoices.create!(
      customer: @customer,
      status: 'returned',
      created_at: '2023-01-01'
    )

    @invoice_two = @merchant_two.invoices.create!(
      customer: @customer,
      status: 'shipped',
      created_at: '2023-01-02'
    )
    end

  describe 'GET /api/v1/merchants' do
    it 'fetches all merchants' do

      get '/api/v1/merchants'

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchants.count).to eq(3)
      expect(merchants[0][:attributes][:name]).to eq(@merchant_one.name)
      expect(merchants[1][:attributes][:name]).to eq(@merchant_two.name)
      expect(merchants[2][:attributes][:name]).to eq(@merchant_three.name)

      expect(merchants[0][:attributes][:name]).to be_a(String)
    end

    it 'fetches merchants sorted by age' do
      
      get '/api/v1/merchants', params: { sorted: 'age' }
  
      
      expect(response).to be_successful
      expect(response.status).to eq(200)
  
      
      merchants = JSON.parse(response.body, symbolize_names: true)[:data]
  
      
      expect(merchants[0][:attributes][:name]).to eq(@merchant_three.name)  
      expect(merchants[1][:attributes][:name]).to eq(@merchant_two.name)
      expect(merchants[2][:attributes][:name]).to eq(@merchant_one.name)  
    end

    it 'fetches the total count of merchants' do
      get '/api/v1/merchants', params: { count: 'true' }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants = JSON.parse(response.body, symbolize_names: true)[:data]
      
      expect(merchants.count).to eq(3)  
    end

    it 'fetches merchants with returns' do
      get '/api/v1/merchants', params: { status: 'returned' }
    
      expect(response).to be_successful
    
      merchants = JSON.parse(response.body, symbolize_names: true)[:data]
    
      expect(merchants).to be_an(Array)
      expect(merchants.size).to eq(1)
    
      returned_merchant = merchants.first
    
      expect(returned_merchant[:id].to_i).to eq(@merchant_one.id)
    end
  end

  it 'fetches a single merchant' do
    get "/api/v1/merchants/#{@merchant_two.id}"

    expect(response).to be_successful
    expect(response.status).to eq(200)

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant[:id]).to be_a(String)
    expect(merchant[:id].to_i).to eq(@merchant_two.id)
    expect(merchant[:type]).to eq('merchant')

    expect(merchant[:attributes][:name]).to eq(@merchant_two.name)
  end

  it 'displays a 404 when record is not found' do
    get "/api/v1/merchants/999999"

    expect(response.status).to eq(404)
    expect(response.body).to include("Record Not Found")
  end

  describe 'POST /api/v1/merchants' do
    it 'can create a merchant' do

      new_merchant = { name: "Mean Joe Bean's Wu-Tang Store" }
      post '/api/v1/merchants', params: {merchant: new_merchant} 

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchant[:id]).to be_a(String)
      expect(merchant[:attributes][:name]).to eq("Mean Joe Bean's Wu-Tang Store")
    end

    it 'returns a 422 when validation fails' do
      post "/api/v1/merchants", params: { merchant: { name: ""} }
    
      
      expect(response.status).to eq(422)
      expect(response.body).to include("Name can't be blank")
    end

    it 'returns a 400 when required parameters are missing' do
      
      post "/api/v1/merchants", params: { item: { } }
    
      expect(response.status).to eq(400)
      expect(response.body).to include("Bad Request")
      expect(response.body).to include('param is missing or the value is empty: merchant')
    end

    it 'returns a 422 bad request for parse errors' do
      
      post "/api/v1/merchants", 
        params: '{ invalid_json: "malformed }', 
        headers: { 'Content-Type' => 'application/json' }
      
      expect(response.status).to eq(400)
      expect(response.body).to include('Bad Request')
      expect(response.body).to include('Error occurred while parsing request parameters')
    end
  end

  describe 'PATCH /api/v1/merchants/:id' do
    it 'can edit an existing merchant' do

      current_store_name = @merchant_three.name

      updated_params = {name: "Montana's Collectables"}

      patch "/api/v1/merchants/#{@merchant_three.id}", params: { merchant: updated_params}
      
      merchant = Merchant.find_by(id: @merchant_three.id)

      expect(response).to be_successful

      expect(merchant.name).to_not eq(current_store_name)
      expect(merchant.name).to eq("Montana's Collectables")
    end

    it 'returns error when validation fails' do
      patch "/api/v1/merchants/#{@merchant_three.id}", params: { merchant: { name: '' } }
    
      expect(response.status).to eq(422)
      
      error_response = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to be(422)
      expect(response.message).to include("Unprocessable Content")
    end
  end

  describe 'DELETE /api/v1/merchants/:id' do
    it 'can delete an existing merchant' do
      
      merchants = Merchant.all
      expect(merchants.count).to eq(3)

      delete "/api/v1/merchants/#{@merchant_one.id}"

      expect(merchants.count).to eq(2)
    end
  end

  describe 'GET /api/v1/merchants/find' do
    it 'returns the merchant data when found' do
     
      get '/api/v1/merchants/find', params: { name: 'Matt\'s Computer Repair Store' }
  
      expect(response).to be_successful
      expect(response.status).to eq(200)
  
      json_response = JSON.parse(response.body, symbolize_names: true)
  
      expect(json_response[:data][:id].to_i).to eq(@merchant_one.id)
      expect(json_response[:data][:attributes][:name]).to eq('Matt\'s Computer Repair Store')
    end
  
    it 'returns an empty object when no merchant is found' do
      get '/api/v1/merchants/find', params: { name: 'Nonexistent Merchant' }
  
      expect(response).to be_successful
      expect(response.status).to eq(200)
  
      json_response = JSON.parse(response.body, symbolize_names: true)
  
      expect(json_response[:data]).to eq({})
    end
  end
end
