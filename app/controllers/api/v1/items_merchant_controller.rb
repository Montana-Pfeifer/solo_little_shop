class Api::V1::ItemsMerchantController < ApplicationController

    def index
        item = Item.find(params[:id])
        merchant = Item.fetch_merchant(item)
        render json: MerchantSerializer.format_merchant(merchant)
    end
end