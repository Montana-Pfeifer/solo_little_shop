require 'pry'

class Api::V1::ItemsController < ApplicationController

    def index
        items = Item.all 
        render json: ItemSerializer.format_items(items)
        
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

    def find_all
        if params[:name]
            items = Item.find_by_name(params[:name])
        else params[:min_price] || params[:max_price]
            items = Item.find_by_price(params)
        end
        
        if items.any?
            render json: ItemSerializer.format_items(items)
        end
    end

    private

    def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end

end