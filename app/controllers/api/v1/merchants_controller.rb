class Api::V1::MerchantsController < ApplicationController

  def index
    if params[:sorted] == 'age'
      merchants = Merchant.merchants_by_age
      render json: MerchantSerializer.format_merchants(merchants)
    elsif params[:count] == 'true'
      merchants = Merchant.all
      render json: MerchantSerializer.format_merchants_count(merchants)
    elsif params[:status] == 'returned'
      merchants = Merchant.merchants_with_returns 
      render json: MerchantSerializer.format_merchants(merchants)
    else
      merchants = Merchant.all
      render json: MerchantSerializer.format_merchants(merchants)
    end
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.format_merchant(merchant)    
  end

  def create
    new_merchant = Merchant.create!(merchant_params)
    render json: MerchantSerializer.format_merchant(new_merchant), status: :created
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.update!(merchant_params)
    render json: MerchantSerializer.format_merchant(merchant)
  end

  def destroy
    Merchant.find(params[:id]).destroy
  end
   
  def find
    merchants = Merchant.find_by_name(params[:name])
    
    if merchants.empty?
      render json: { data: {} }, status: :ok
    else
      render json: MerchantSerializer.format_merchant(merchants.first), status: :ok
    end
  end

  private
  
  def merchant_params
    params.require(:merchant).permit(:name)
  end

end