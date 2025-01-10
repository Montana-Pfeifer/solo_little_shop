require 'rails_helper'

RSpec.describe "Customer API", type: :request do
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
      customer_id: @customer1.id ,
      merchant_id: @merchant_three.id,
      status: "shipped"
    )

    @invoice2 = Invoice.create!(
      customer_id: @customer2.id,
      merchant_id: @merchant_one.id,
      status: "returned"
    )

    @invoice3 = Invoice.create!(
      customer_id: @customer3.id,
      merchant_id: @merchant_one.id,
      status: "shipped"
    )

    @invoice4 = Invoice.create!(
      customer_id: @customer4.id,
      merchant_id: @merchant_one.id,
      status: "returned"
    )

    @invoice5 = Invoice.create!(
      customer_id: @customer5.id,
      merchant_id: @merchant_one.id,
      status: "shipped"
    )
  end

  describe 'GET /api/v1/merchants/:merchant_id/customers' do
    it 'fetches all customers that have an invoice with a specific merchant' do

      get "/api/v1/merchants/#{@merchant_one.id}/customers"
      expect(response).to be_successful
      expect(response.status).to eq(200)

      customers = JSON.parse(response.body, symbolize_names: true)[:data]

      customers.each do |customer|
        expect(customer[:id]).to be_a(String)
        expect(customer[:type]).to eq('customer')
        expect(customer[:attributes][:first_name]).to be_a(String)
        expect(customer[:attributes][:last_name]).to be_a(String)
      end

      expect(customers.count).to eq(4)
      expect(customers).to be_an(Array)
      expect(customers[0][:attributes][:first_name]).to eq("Seymour")
      expect(customers[0][:attributes][:last_name]).to eq("Butts")
      expect(customers[1][:attributes][:first_name]).to eq("Method")
      expect(customers[1][:attributes][:last_name]).to eq("Man")
      expect(customers[2][:attributes][:first_name]).to eq("Marshal")
      expect(customers[2][:attributes][:last_name]).to eq("Mathers")
      expect(customers[3][:attributes][:first_name]).to eq("Nathan")
      expect(customers[3][:attributes][:last_name]).to eq("Feuerstein")
    end

    it 'Returns an array even if only one invoice is found for that specific merchant' do

      get "/api/v1/merchants/#{@merchant_three.id}/customers"
      expect(response).to be_successful
      expect(response.status).to eq(200)

      customers = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(customers.count).to eq(1)
      expect(customers).to be_an(Array)
      expect(customers[0][:attributes][:first_name]).to eq("Billy")
      expect(customers[0][:attributes][:last_name]).to eq("Bob")
    end
    
    it 'Returns an empty array of customers if no invoices for that specific merchant' do
      
      get "/api/v1/merchants/#{@merchant_two.id}/customers"
      expect(response).to be_successful
      expect(response.status).to eq(200)
      
      customers = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(customers.count).to eq(0)
      expect(customers).to be_an(Array)
    end
  end

  it 'displays 404 error if merchant id doesn\'t exist' do
    get "/api/v1/merchants/133713371337/customers"
 
    expect(response.status).to eq(404)
    expect(response.body).to include("Record Not Found")
  end
end