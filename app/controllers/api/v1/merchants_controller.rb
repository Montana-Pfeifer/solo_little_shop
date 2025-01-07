class Api::V1::MerchantsController < ApplicationController

  def index
    merchants = Merchant.all
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

  def merchant_params
    params.require(:merchant).permit(:name)
  end

end