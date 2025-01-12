require 'rails_helper'

RSpec.describe "Invoices API", type: :request do
  before(:each) do
  
    @merchant_one = Merchant.create!(name: 'Matt\'s Computer Repair Store')
    @merchant_two = Merchant.create!(name: 'Natasha\'s Taylor Swift Store')
    @merchant_three = Merchant.create!(name: 'Montana\'s Pokemon Cards Store')

    @customer1 = Customer.create!(first_name: "Billy", last_name: "Bob")
    @customer2 = Customer.create!(first_name: "Seymour", last_name: "Butts")
    @customer3 = Customer.create!(first_name: "Method", last_name: "Man")
    @customer4 = Customer.create!(first_name: "Marshal", last_name: "Mathers")
    @customer5 = Customer.create!(first_name: "Nathan", last_name: "Feuerstein")

    @invoice1 = Invoice.create!(
      customer_id: @customer4.id,
      merchant_id: @merchant_two.id,
      status: 'shipped',
    )

    @invoice2 = Invoice.create!(
      customer_id: @customer1.id,
      merchant_id: @merchant_three.id,
      status: 'returned',
    )

    @invoice3 = Invoice.create!(
      customer_id: @customer2.id,
      merchant_id: @merchant_one.id,
      status: 'shipped',
    )

    @invoice4 = Invoice.create!(
      customer_id: @customer3.id,
      merchant_id: @merchant_two.id,
      status: 'packaged',
    )

    @invoice5 = Invoice.create!(
      customer_id: @customer5.id,
      merchant_id: @merchant_one.id,
      status: 'shipped',
    )

    @invoice6 = Invoice.create!(
      customer_id: @customer2.id,
      merchant_id: @merchant_three.id,
      status: 'shipped',
    )

    @invoice7 = Invoice.create!(
      customer_id: @customer3.id,
      merchant_id: @merchant_one.id,
      status: 'packaged',
    )

    @invoice8 = Invoice.create!(
      customer_id: @customer1.id,
      merchant_id: @merchant_two.id,
      status: 'shipped',
    )
  end

  describe 'GET /api/v1/merchants/:merchant_id/invoices' do
    it 'fetches all invoices for a specific merchant when no status is provided' do

      get "/api/v1/merchants/#{@merchant_one.id}/invoices"
      expect(response).to be_successful
      expect(response.status).to eq(200)

      invoices = JSON.parse(response.body, symbolize_names: true)[:data]

      invoices.each do |invoice|
        expect(invoice[:id]).to be_a(String)
        expect(invoice[:type]).to eq('invoice')
        expect(invoice[:attributes][:customer_id]).to be_a(Integer)
        expect(invoice[:attributes][:merchant_id]).to be_a(Integer)
        expect(invoice[:attributes][:status]).to be_a(String)
        expect(invoice[:attributes][:status]).to eq('shipped').or eq('returned').or eq('packaged')
      end
      expect(invoices).to be_a(Array)
      expect(invoices.count).to eq(3)
    end
  end

  describe 'GET /api/v1/merchants/:merchant_id/invoices?status=<status>' do
    it 'fetches all invoices for a specific merchant with the status "shipped"' do
  
      get "/api/v1/merchants/#{@merchant_two.id}/invoices?status=shipped"
      expect(response).to be_successful
      expect(response.status).to eq(200)
  
      invoices = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(invoices.count).to eq(2)
      expect(invoices[0][:attributes][:customer_id]).to eq(@customer4.id)
      expect(invoices[0][:attributes][:merchant_id]).to eq(@merchant_two.id)
      expect(invoices[0][:attributes][:status]).to eq('shipped')
      expect(invoices[1][:attributes][:customer_id]).to eq(@customer1.id)
      expect(invoices[1][:attributes][:merchant_id]).to eq(@merchant_two.id)
      expect(invoices[1][:attributes][:status]).to eq('shipped')
    end

    it 'fetches all invoices for a specific merchant with the status "returned"' do
  
      get "/api/v1/merchants/#{@merchant_three.id}/invoices?status=returned"
      expect(response).to be_successful
      expect(response.status).to eq(200)
  
      invoices = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(invoices.count).to eq(1)
      expect(invoices[0][:attributes][:customer_id]).to eq(@customer1.id)
      expect(invoices[0][:attributes][:merchant_id]).to eq(@merchant_three.id)
      expect(invoices[0][:attributes][:status]).to eq('returned')
    end

    it 'fetches all invoices for a specific merchant with the status "packaged"' do
  
      get "/api/v1/merchants/#{@merchant_two.id}/invoices?status=packaged"
      expect(response).to be_successful
      expect(response.status).to eq(200)
  
      invoices = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(invoices.count).to eq(1)
      expect(invoices[0][:attributes][:customer_id]).to eq(@customer3.id)
      expect(invoices[0][:attributes][:merchant_id]).to eq(@merchant_two.id)
      expect(invoices[0][:attributes][:status]).to eq('packaged')
    end

    it 'returns an empty data array if no invoice match the status criteria' do
  
      get "/api/v1/merchants/#{@merchant_one.id}/invoices?status=returned"
      expect(response).to be_successful
      expect(response.status).to eq(200)
  
      invoices = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(invoices.count).to eq(0)
    end

    it 'displays 404 error if merchant id doesn\'t exist' do
      get "/api/v1/merchants/133713371337/invoices?status=packaged"
  
      expect(response.status).to eq(404)
      expect(response.body).to include("Record Not Found")
    end
  end
end