class Api::V1::CouponsController < ApplicationController
  def index
    coupons = Coupon.all
    
    render json: CouponSerializer.format_coupons(coupons)
  end
end