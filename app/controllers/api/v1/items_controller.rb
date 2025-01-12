class Api::V1::ItemsController < ApplicationController

    def index
        if params[:sorted] == "price"
            items = Item.sort_by_price
            render json:ItemSerializer.format_items(items)
        else 
            items = Item.all
            render json:ItemSerializer.format_items(items)
        end
    end

    def show
        item = Item.find(params[:id])
        render json: ItemSerializer.format_item(item)
    end

    def create
        item = Item.create!(item_params)
        render json: ItemSerializer.format_item(item), status: :created
    end

    def update
        item = Item.find(params[:id])
        item.update!(item_params)
        render json: ItemSerializer.format_item(item)
    end

    def destroy
        item = Item.find(params[:id])
        item.destroy
    end



    private

    def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end

end