require 'rails_helper'

RSpec.describe "Merchants API", type: :request do
  before(:each) do
    @merchant_one = Merchant.create!(name: 'Matt\'s Computer Repair Store')
    @merchant_two = Merchant.create!(name: 'Natasha\'s Taylor Swift Store')
    @merchant_three = Merchant.create!(name: 'Montana\'s Pokemon Cards Store')
  end

  describe 'GET /api/v1/merchants' do
    it 'fetches all merchants' do

      get '/api/v1/merchants'

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchants = JSON.parse(response.body, symbolize_names: true)[:data]

      merchant = merchants[0]
      expect(merchant[:id]).to be_a(String)
      expect(merchant[:type]).to eq('merchant')

      expect(merchant[:attributes][:name]).to be_a(String)
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

  describe 'POST /api/v1/merchants' do
    it 'can create a merchant' do

      new_merchant = { name: "Mean Joe Bean's Wu-Tang Store" }
      post '/api/v1/merchants', params: {merchant: new_merchant} 

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchant[:id]).to be_a(String)
      expect(merchant[:attributes][:name]).to eq("Mean Joe Bean's Wu-Tang Store")
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
  end

  describe 'DELETE /api/v1/merchants/:id' do
    it 'can delete an existing merchant' do
      
      merchants = Merchant.all
      expect(merchants.count).to eq(3)

      delete "/api/v1/merchants/#{@merchant_one.id}"

      expect(merchants.count).to eq(2)
    end
  end
end
