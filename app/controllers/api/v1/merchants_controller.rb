class Api::V1::MerchantsController < ApplicationController

  def index
    if params[:sorted] == 'age'
      merchants = Merchant.merchants_by_age
      render json: MerchantSerializer.format_merchants_json(merchants)
    elsif params[:count] === 'true'
      merchants = Merchant.all
      render json: MerchantSerializer.format_merchants_count_json(merchants)
    elsif params[:status] == 'returned'
        merchants = Merchant.merchants_with_returns 
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
    new_merchant = Merchant.create!(merchant_params)
    
      render json: MerchantSerializer.format_merchant_json(new_merchant), status: :created
    # else
    #   render json: ErrorSerializer.format_error(422, new_merchant.errors.full_messages.join(", "), "Validation Error"), status: :unprocessable_entity
  end

  def update
    merchant = Merchant.find(params[:id])
      if merchant.update(merchant_params)
        render json: MerchantSerializer.format_merchant_json(merchant)
      else
        render json: ErrorSerializer.format_error(422, merchant.errors.full_messages.join(", "), "Validation Error"), status: :unprocessable_entity
    end
  end

  def destroy
    Merchant.find(params[:id]).destroy
  end

  private
  
  def merchant_params
    params.require(:merchant).permit(:name)
  end

end