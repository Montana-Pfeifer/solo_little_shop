require 'rails_helper'

RSpec.describe "Coupons API", type: :request do
  before(:each) do
    @merchant = Merchant.create!(name: "Test Merchant")
    @coupon1 = Coupon.create!(name: "Discount 1", code: "SAVE10", discount_type: "percentage", value: 10, merchant: @merchant, status: true)
    @coupon2 = Coupon.create!(name: "Discount 2", code: "SAVE20", discount_type: "fixed", value: 20, merchant: @merchant)

    @customer = Customer.create!(first_name: "John", last_name: "Doe")
  end

  describe "GET /api/v1/merchants/:merchant_id/coupons" do
    it "returns all coupons for a merchant" do
      get "/api/v1/merchants/#{@merchant.id}/coupons"

      response_data = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(response_data['data'].length).to eq(2)
      expect(response_data['data'][0]['attributes']['code']).to eq("SAVE10")
      expect(response_data['data'][1]['attributes']['code']).to eq("SAVE20")
    end
  end

  describe "GET /api/v1/merchants/:merchant_id/coupons/:id" do
    it "returns a specific coupon for a merchant" do
      get "/api/v1/merchants/#{@merchant.id}/coupons/#{@coupon1.id}"

      response_data = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(response_data['data']['attributes']['code']).to eq(@coupon1.code)
      expect(response_data['data']['attributes']['name']).to eq(@coupon1.name)
    end

    it "returns a 404 not found error for a missing coupon" do
      get "/api/v1/merchants/#{@merchant.id}/coupons/9999"
      
      response_data = JSON.parse(response.body)
      
      expect(response.status).to eq(404)
      expect(response_data['error']['status']).to eq("404")
      expect(response_data['error']['message']).to eq("An error occurred")
    end
    
    
  end

  describe "POST /api/v1/merchants/:merchant_id/coupons" do
    it "creates a new coupon for a merchant" do
      post "/api/v1/merchants/#{@merchant.id}/coupons", params: {
        coupon: { name: "New Discount", code: "NEW10", discount_type: "percentage", value: 15 }
      }

      response_data = JSON.parse(response.body)

      expect(response).to have_http_status(:created)
      expect(response_data['data']['attributes']['code']).to eq("NEW10")
      expect(response_data['data']['attributes']['name']).to eq("New Discount")
    end

    it "returns an error if coupon code already exists for the merchant" do
      post "/api/v1/merchants/#{@merchant.id}/coupons", params: {
        coupon: { name: "Duplicate Discount", code: "SAVE10", discount_type: "percentage", value: 10 }
      }

      response_data = JSON.parse(response.body)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_data['error']).to include("Code has already been taken for this merchant")
    end
  end

  describe "PATCH /api/v1/merchants/:merchant_id/coupons/:id/activate" do
    it "activates a coupon" do
      patch "/api/v1/merchants/#{@merchant.id}/coupons/#{@coupon2.id}/activate"

      response_data = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(response_data['data']['attributes']['status']).to eq("active")
    end

    it "returns an error if coupon is already active" do
      @coupon1.update(status: true)

      patch "/api/v1/merchants/#{@merchant.id}/coupons/#{@coupon1.id}/activate"
      
      response_data = JSON.parse(response.body)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_data['error']).to eq("Coupon is already active.")
    end
  end

  describe "PATCH /api/v1/merchants/:merchant_id/coupons/:id/deactivate" do
    it "deactivates a coupon" do
      patch "/api/v1/merchants/#{@merchant.id}/coupons/#{@coupon1.id}/deactivate"

      response_data = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(response_data['data']['attributes']['status']).to eq("inactive")
    end

    it "returns an error if coupon is already inactive" do
      @coupon1.update(status: false)

      patch "/api/v1/merchants/#{@merchant.id}/coupons/#{@coupon1.id}/deactivate"

      response_data = JSON.parse(response.body)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_data['error']).to eq("Coupon is already inactive.")
    end

    it "returns an error if there are pending invoices" do
        
      Invoice.create!(merchant: @merchant, coupon: @coupon1, customer: @customer, status: "pending")
    
      patch "/api/v1/merchants/#{@merchant.id}/coupons/#{@coupon1.id}/deactivate"
      
      response_data = JSON.parse(response.body)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_data['error']).to eq("Cannot deactivate coupon with pending invoices.")

    end
  end
end
