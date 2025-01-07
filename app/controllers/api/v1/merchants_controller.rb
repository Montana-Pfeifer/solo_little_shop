class Api::V1::MerchantsController < ApplicationController

  def index
    merchants = Merchant.all
    render json: MerchantSerializer.format_merchants_json(merchants)
  end

  def merchant_params
    params.require(:merchant).permit(:name)
  end

end