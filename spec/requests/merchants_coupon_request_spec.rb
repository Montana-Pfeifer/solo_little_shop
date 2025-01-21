require 'rails_helper'

RSpec.describe "Coupons API", type: :request do
  before(:each) do
    @merchant = Merchant.create!(name: "Test Merchant")
    @merchant2 = Merchant.create!(name: "Test Merchant 2")

    @active_coupon = Coupon.create!(name: "Active Discount", code: "SAVE10", discount_type: "percentage", value: 10, merchant: @merchant, status: true)
    @active_coupon2 = Coupon.create!(name: "Active Discount 2", code: "SAVE30", discount_type: "percentage", value: 30, merchant: @merchant2, status: true)
    @inactive_coupon = Coupon.create!(name: "Inactive Discount", code: "SAVE20", discount_type: "fixed", value: 20, merchant: @merchant, status: false)
    
    @customer = Customer.create!(first_name: "John", last_name: "Doe")

    @invoice = Invoice.create!(
      customer: @customer,
      merchant: @merchant,
      status: "pending",
      coupon: @active_coupon
    )

    @invoice2 = Invoice.create!(
      customer: @customer,
      merchant: @merchant,
      status: "shipped",
      coupon: @active_coupon2
    )
  end

  describe "GET /api/v1/merchants/:merchant_id/coupons" do
    it "fetches all coupons for a merchant" do
      get "/api/v1/merchants/#{@merchant.id}/coupons"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      response_data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response_data.count).to eq(2)
      expect(response_data[0][:attributes][:code]).to eq("SAVE10")
      expect(response_data[1][:attributes][:code]).to eq("SAVE20")
    end
  end

  describe "GET /api/v1/merchants/:merchant_id/coupons/:id" do
    it "fetches a specific coupon" do
      get "/api/v1/merchants/#{@merchant.id}/coupons/#{@active_coupon.id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      response_data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response_data[:attributes][:code]).to eq(@active_coupon.code)
      expect(response_data[:attributes][:name]).to eq(@active_coupon.name)
    end

    it "returns a 404 when coupon is not found" do
      get "/api/v1/merchants/#{@merchant.id}/coupons/9999"

      expect(response.status).to eq(404)
      expect(response.body).to include("Record Not Found")
    end
  end

  describe "POST /api/v1/merchants/:merchant_id/coupons" do
    it "creates a new coupon" do
      post "/api/v1/merchants/#{@merchant.id}/coupons", params: {
        coupon: { name: "New Discount", code: "NEW10", discount_type: "percentage", value: 15 }
      }

      expect(response).to be_successful
      expect(response.status).to eq(201)

      response_data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response_data[:attributes][:code]).to eq("NEW10")
      expect(response_data[:attributes][:name]).to eq("New Discount")
    end

    it "returns an error if coupon code already exists" do
      post "/api/v1/merchants/#{@merchant.id}/coupons", params: {
        coupon: { name: "Duplicate Discount", code: "SAVE10", discount_type: "percentage", value: 10 }
      }

      expect(response.status).to eq(422)
      response_data = JSON.parse(response.body, symbolize_names: true)
      expect(response_data[:errors][:detail]).to eq("Code has already been taken for this merchant")
    end
  end

  describe "PATCH /api/v1/merchants/:merchant_id/coupons/:id/activate" do
    it "activates a coupon" do
      patch "/api/v1/merchants/#{@merchant.id}/coupons/#{@inactive_coupon.id}/activate"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      response_data = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(response_data[:attributes][:status]).to eq("active")
    end

    it "returns an error if the coupon is already active" do
      patch "/api/v1/merchants/#{@merchant.id}/coupons/#{@active_coupon.id}/activate"

      expect(response.status).to eq(422)
      response_data = JSON.parse(response.body, symbolize_names: true)
      expect(response_data[:error][:detail]).to eq("Coupon is already active.")
    end
  end

  describe "PATCH /api/v1/merchants/:merchant_id/coupons/:id/deactivate" do
    it "deactivates a coupon" do
      patch "/api/v1/merchants/#{@merchant.id}/coupons/#{@active_coupon.id}/deactivate"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      response_data = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(response_data[:attributes][:status]).to eq(false)
    end

    it "returns a 422 error with the message 'Coupon is already inactive.'" do
      patch "/api/v1/merchants/#{@merchant.id}/coupons/#{@inactive_coupon.id}/deactivate"

      expect(response.status).to eq(422)
      expect(response_data[:errors][:detail]).to eq("Coupon is already inactive.")
    end
  

    it "returns an error if there are pending invoices" do
      patch "/api/v1/merchants/#{@merchant.id}/coupons/#{@active_coupon.id}/deactivate"

      expect(response.status).to eq(422)
      response_data = JSON.parse(response.body, symbolize_names: true)
      expect(response_data[:errors][:detail]).to eq("Cannot deactivate coupon with pending invoices.")
    end
  end
end
