class Api::V1::CouponsController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])
  
    if params[:status].present?
      coupons = Coupon.filter_by_status(merchant, params[:status])
  
      if coupons.nil? || coupons.empty?
        raise ActiveRecord::RecordNotFound, "No coupons found for this status."
      end

    else
      coupons = merchant.coupons
    end
  
    render json: CouponSerializer.format_coupons(coupons), status: :ok
  end
  

  def show
    merchant = Merchant.find_by(id: params[:merchant_id])
    raise ActiveRecord::RecordNotFound, "Merchant not found" if merchant.nil?

    coupon = Coupon.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound, "Coupon not found for this merchant." if coupon.nil?

    render json: CouponSerializer.format_coupon(coupon)
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    new_coupon = merchant.coupons.create(coupon_params)

    if new_coupon.persisted?
      render json: CouponSerializer.format_coupon(new_coupon), status: :created
    else
      raise ActiveRecord::RecordInvalid.new(new_coupon)
    end
  end
#vvvvvvvvv merge to update vvvvvvvvvvvv
  def deactivate
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound, "Coupon not found for this merchant." if coupon.nil?
  
    validate_coupon_for_deactivation(coupon)
  
    coupon.update!(status: false)
  
    render json: CouponSerializer.format_coupon(coupon), status: :ok
  end
  
  def activate
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound, "Coupon not found for this merchant." if coupon.nil?
  
    validate_coupon_for_activation(coupon)
  
    coupon.update!(status: true)
    render json: CouponSerializer.format_coupon(coupon), status: :ok
  end
  
  
  
  



  private

  def coupon_params
    params.require(:coupon).permit(:name, :code, :discount_type, :value, :status)
  end
end
