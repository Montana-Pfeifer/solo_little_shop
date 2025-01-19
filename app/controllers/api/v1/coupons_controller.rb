class Api::V1::CouponsController < ApplicationController
  class Api::V1::CouponsController < ApplicationController
    def index
      merchant = Merchant.find_by(id: params[:merchant_id])
      coupons = merchant.coupons
      render json: CouponSerializer.format_coupons(coupons)
    end
  end
  

  def show
    coupon = Coupon.find(params[:id])
    render json: CouponSerializer.format_coupon(coupon)
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    new_coupon = merchant.coupons.create(coupon_params)

  
    if new_coupon.persisted?
      render json: CouponSerializer.format_coupon(new_coupon), status: :created
    else
      render json: { error: new_coupon.errors.full_messages }, status: :unprocessable_entity
    end
   
  end


  private

  def coupon_params
    params.require(:coupon).permit(:name, :code, :discount_type, :value, :status)
  end
  
end