class Api::V1::CouponsController < ApplicationController
  def index
    merchant = Merchant.find_by(id: params[:merchant_id])
    coupons = merchant.coupons
    render json: CouponSerializer.format_coupons(coupons)
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

  def deactivate
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound, "Coupon not found for this merchant." if coupon.nil?
  
    if coupon.status == "inactive"
      raise InvalidCouponStatusError, "Coupon is already inactive."
    end
  
    if coupon.invoices.pending.exists?
      raise InvalidCouponStatusError, "Cannot deactivate coupon with pending invoices."
    end
  
    coupon.update!(status: "inactive")
    render json: CouponSerializer.format_coupon(coupon), status: :ok
  end
  

  def activate
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound, "Coupon not found for this merchant." if coupon.nil?
  
    if coupon.status == "active"
      raise InvalidCouponStatusError, "Coupon is already active."
    end
  
    if coupon.invoices.pending.exists?
      raise InvalidCouponStatusError, "Cannot activate coupon with pending invoices."
    end

    coupon.update!(status: "active")
    render json: CouponSerializer.format_coupon(coupon), status: :ok
  end
  
  

  private

  def coupon_params
    params.require(:coupon).permit(:name, :code, :discount_type, :value, :status)
  end
end
