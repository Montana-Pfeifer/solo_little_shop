class Api::V1::ItemsController < ApplicationController
    before_action :validate_price_params, only: [:find_all]

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

    def find_all
        if params[:name].present? && (params[:min_price].present? || params[:max_price].present?)
            raise InvalidPriceParamsError, 'Cannot search by name and price range simultaneously'
        end
      
        if (params[:min_price].present? && !valid_number?(params[:min_price])) || (params[:max_price].present? && !valid_number?(params[:max_price]))
            raise InvalidPriceParamsError, 'Price must be a valid number'
        end
    
        items = if params[:name].present?
                    Item.find_by_name(params[:name])
                elsif params[:min_price].present? || params[:max_price].present?
                    Item.find_by_price(params)
                else
                    Item.all
                end
    
        render json: ItemSerializer.format_items(items), status: :ok
    end
    
      
      
      

    private

    def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end

    def valid_number?(value)
        !!Float(value) rescue false
    end
      
end