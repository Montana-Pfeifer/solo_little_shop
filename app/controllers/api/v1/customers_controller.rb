class Api::V1::CustomersController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])
    customers = Customer.fetch_customers_per_merchant(merchant)
    render json: CustomerSerializer.format_customers(customers)
  end
end