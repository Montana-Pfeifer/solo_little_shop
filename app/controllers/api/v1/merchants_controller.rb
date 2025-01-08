class Api::V1::MerchantsController < ApplicationController

  def index
    if params[:sorted].present?
      merchants = Merchant.merchants_by_age()
    else 
      merchants = Merchant.all
    end

    render json: MerchantSerializer.format_merchants_json(merchants)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.format_merchant_json(merchant)
  end

  def create
    new_merchant = Merchant.create(merchant_params)
    render json: MerchantSerializer.format_merchant_json(new_merchant)
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.update(merchant_params)
    render json: MerchantSerializer.format_merchant_json(merchant)
  end

  def merchant_params
    params.require(:merchant).permit(:name)
  end

end