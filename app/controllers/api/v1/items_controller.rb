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
    item = Item.create(item_params)
        if item.valid?
            render json: ItemSerializer.format_item(item), status: :created
        else
            render json: ErrorSerializer.format_error(422, item.errors.full_messages.join(", "), "Validation Error"), status: :unprocessable_entity
        end
  end

    def update
        item = Item.find(params[:id])
        item.update(item_params)
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