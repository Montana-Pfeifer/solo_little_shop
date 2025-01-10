class Api::V1::MerchantsItemsController < ApplicationController

  def index
    merchant = Merchant.find(params[:id])
    items = Merchant.fetch_all_items(merchant)
    render json: ItemSerializer.format_items(items)
  end
end