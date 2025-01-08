class Api::V1::MerchantsController < ApplicationController

  def index
    if params[:sorted] == 'age'
      merchants = Merchant.merchants_by_age
      render json: MerchantSerializer.format_merchants_json(merchants)
    elsif params[:count] === 'true'
      merchants = Merchant.all
      render json: MerchantSerializer.format_merchants_count_json(merchants)
    elsif params[:status] == 'returned'
      merchants = Merchant.all
      merchants = Merchant.merchants_with_returns(merchants)
      render json: MerchantSerializer.format_merchants_json(merchants)
    else
      merchants = Merchant.all
      render json: MerchantSerializer.format_merchants_json(merchants)
    end
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

  def destroy
    Merchant.find(params[:id]).destroy
  end

  def merchant_params
    params.require(:merchant).permit(:name)
  end

end